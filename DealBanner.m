//
//  DealBanner.m
//  Venere
//
//  Created by John Green on 19/12/2012.
//
//

#import "DealBanner.h"
#import "UIView+Extension.h"
#import "NSNumber+Extension.h"
#import "LocalizationProvider.h"

#define MARGIN 8
#define LEFT_BANNER     @"PromoBannerRed"
#define RIGHT_BANNER    @"PromoBannerOrange"
#define RIGHT_OFFSET    7

@interface DealBanner () {}
@end


@implementation DealBanner {
    CGLayerRef _bufferlayer;
    enum MasDealTypes _dealTypes;
    NSNumber * _dealPercentage;
    NSString *_discountFormatString;
    NSString *_specialPriceString;
    NSString *_appOnlyString;
    NSString *_mobileOnlyString;
}

- (void) drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (_bufferlayer == NULL) {
        // if contains DDR
        if (_dealTypes & MasDealDRR) {
            //draw the banner image
            float scale = [self contentScaleFactor];
            _bufferlayer = CGLayerCreateWithContext(ctx, CGSizeMake(rect.size.width * scale, rect.size.height * scale), NULL);
            
            CGContextRef bufferCtx = CGLayerGetContext(_bufferlayer);
            
            
            CGContextScaleCTM(bufferCtx, scale, scale);
            
            UIGraphicsPushContext(bufferCtx);
            CGContextSetRGBFillColor(bufferCtx, 1, 1, 1, 1);
            UIFont *font = [UIFont fontWithName:@"OpenSans" size:11];
            
            UIImage *leftBanner = [UIImage imageNamed:LEFT_BANNER];
            [leftBanner drawAtPoint:CGPointMake(0, 0)];
            
            //then the text
            NSString *leftBannerText;
            
            leftBannerText = _specialPriceString;
            
            CGSize textSize = [leftBannerText sizeWithFont:font];
            
            CGRect leftRect = CGRectMake((leftBanner.size.width - textSize.width) / 2, (leftBanner.size.height - textSize.height) / 2, textSize.width, textSize.height);
            [leftBannerText drawInRect:leftRect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
            int x = leftBanner.size.width;
            
            UIImage *rightBanner = [UIImage imageNamed:RIGHT_BANNER];
            [rightBanner drawAtPoint:CGPointMake(x - RIGHT_OFFSET, 0)];
            
            //then the text
            NSString *rightBannerText = _mobileOnlyString;
            
            textSize = [rightBannerText sizeWithFont:font];
            
            CGRect rightRect = CGRectMake((rightBanner.size.width - textSize.width) / 2 + x - RIGHT_OFFSET, (rightBanner.size.height - textSize.height) / 2, textSize.width, textSize.height);
            [rightBannerText drawInRect:rightRect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
            UIGraphicsPopContext();
        }
        // else if deals contains percentage or special price
        else if ((_dealTypes & MasDealPercentage) > 0 ||
            (_dealTypes & MasDealSpecialPrice) > 0) {
            
            //draw the banner image
            float scale = [self contentScaleFactor];
            _bufferlayer = CGLayerCreateWithContext(ctx, CGSizeMake(rect.size.width * scale, rect.size.height * scale), NULL);
            
            CGContextRef bufferCtx = CGLayerGetContext(_bufferlayer);


            CGContextScaleCTM(bufferCtx, scale, scale);
            
            UIGraphicsPushContext(bufferCtx);
            CGContextSetRGBFillColor(bufferCtx, 1, 1, 1, 1);
            UIFont *font = [UIFont fontWithName:@"OpenSans" size:11];
            
            UIImage *leftBanner = [UIImage imageNamed:LEFT_BANNER];
            [leftBanner drawAtPoint:CGPointMake(0, 0)];
            
            //then the text
            NSString *leftBannerText;
            if ((_dealTypes & MasDealPercentage) > 0) {
                leftBannerText = [_discountFormatString stringByReplacingOccurrencesOfString:@"%percentage_off%" withString: [NSString stringWithFormat:@"%@", [_dealPercentage toString]]];
            } else
                leftBannerText = _specialPriceString;
            
            CGSize textSize = [leftBannerText sizeWithFont:font];
        
            CGRect leftRect = CGRectMake((leftBanner.size.width - textSize.width) / 2, (leftBanner.size.height - textSize.height) / 2, textSize.width, textSize.height);
            [leftBannerText drawInRect:leftRect withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            
            UIGraphicsPopContext();
        }
    }
    CGContextDrawLayerInRect(ctx, rect, _bufferlayer);
}

- (void) update:(MasDeal *) deal {
    
    //update them here as the language could have changed
    _discountFormatString = [LocalizationProvider stringForKey:@"DEAL_OFF_V" withDefault:@"%percentage_off% off!"];
    _specialPriceString = [LocalizationProvider stringForKey:@"DEAL_SPECIAL_PRICE" withDefault:@"Special Price"];
    _appOnlyString = [LocalizationProvider stringForKey:@"DEAL_APP_ONLY" withDefault:@"App only deal!"];
    _mobileOnlyString = [LocalizationProvider stringForKey:@"DEAL_MOBILE_ONLY" withDefault:@"Mobile only"];
    
    if (deal.dealTypes != _dealTypes || ![_dealPercentage isEqualToNumber:deal.dealPercentage]) {
        _dealTypes = deal.dealTypes;
        _dealPercentage = deal.dealPercentage;
        _bufferlayer = NULL;
        [self setNeedsDisplay];
    }
}

@end
