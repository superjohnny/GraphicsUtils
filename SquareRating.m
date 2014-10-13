//
//  SquareRating.m
//  Venere
//
//  Created by John Green on 20/11/2012.
//
//

#import "SquareRating.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Extension.h"

#define PADDING 1.5
#define ANIMATION_DURATION 0.28f

#define EMPTY_CELL  @"SquareGrey"
#define FULL_CELL   @"SquareOrange"
#define HALF_CELL   @"SquareOrangeGrey"


@implementation SquareRating
{
    CGLayerRef _layer;
}


- (void) drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (_layer == NULL) {
        
        float scale = [self contentScaleFactor];
        _layer = CGLayerCreateWithContext(ctx, CGSizeMake(rect.size.width * scale, rect.size.height * scale), NULL);
        CGContextRef bufferCtx = CGLayerGetContext(_layer);
        CGContextScaleCTM(bufferCtx, scale, scale);
        UIGraphicsPushContext(bufferCtx);
        
        //find the size for each square
        int h = rect.size.height; //use the height

        float adjustedValue = _ratingValue / 2;
        
        int x = PADDING;
        for (int i = 0; i < 5; i++) {
        
            UIImage *img = nil;

            float r = adjustedValue - i;
            
            if (r >= 0.9)
                img = [UIImage imageNamed:FULL_CELL];
            else if (r >= 0.5 && r < 0.9)
                img = [UIImage imageNamed:HALF_CELL];
            else
                img = [UIImage imageNamed:EMPTY_CELL];
            
            [img drawInRect:CGRectMake(x, 0, h, h)];
            x += h + PADDING;

        }
        UIGraphicsPopContext();
    }
    CGContextDrawLayerInRect(ctx, rect, _layer);
}



-(void)setRatingValue:(float)ratingValue {
    
    if (ratingValue != _ratingValue) {
        _ratingValue = ratingValue;
        _layer = NULL;

        [self setNeedsDisplay];
    }
}


@end
