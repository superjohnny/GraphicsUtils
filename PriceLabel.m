//
//  PriceLabel.m
//  Venere
//
//  Created by John Green on 19/11/2012.
//
//

#import "PriceLabel.h"
#import "NSString+Extension.h"

#define COLOUR_PRICE_RED                    213/255.0f
#define COLOUR_PRICE_BLACK                  26/255.0f
#define COLOUR_STRIKE_PRICE                 100/255.0f
#define PADDING 3

@interface PriceLabel ()
@property (strong, nonatomic)  NSString *strikePrice;
@property (strong, nonatomic)  NSString *price;
@property (nonatomic)  BOOL hasDeal;
@end

@implementation PriceLabel {
}
/* oh the rules have changed again. */
/* now the price must be shown in red if there is any kind of deal, not just a strike price! */

/*
 The rules for calculating price display
 
 -no strike price
 Price only, in black
 
 -strike price
 Grey strike price, red price
  
 */


static UIFont *strikeFont = nil;
static UIFont *priceFont = nil;


+ (void) initialize {
    if (self == [PriceLabel class]) {
        strikeFont = [UIFont fontWithName:@"OpenSans" size:14];
        priceFont = [UIFont fontWithName:@"OpenSans-Bold" size:17];
    }
}


- (void) update:(NSString *) withPrice andStrikePrice:(NSString *) strikePrice andHasDeal:(BOOL) hasDeal {
    self.price = withPrice;
    self.strikePrice = strikePrice;
    self.hasDeal = hasDeal;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    
    int x = 0;
    CGFloat centerLine = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
    CGFloat textFrameY ;

    //measure each display item
    CGSize strikePriceSize = [_strikePrice sizeWithFont:strikeFont];
    
    CGSize priceSize = [_price sizeWithFont:priceFont];

    //find start point from right hand side
    x = self.bounds.size.width - priceSize.width;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (![NSString isNilOrEmpty: _strikePrice]) {     //draw striked price

        
        x -= strikePriceSize.width;
        x -= PADDING;
        int strikeOrigin = x;
        
        CGFloat lineWidth = 2;
        textFrameY = (centerLine - (strikePriceSize.height / 2));
        CGContextSetRGBFillColor(ctx, COLOUR_STRIKE_PRICE, COLOUR_STRIKE_PRICE, COLOUR_STRIKE_PRICE, 1);
        CGContextSetRGBStrokeColor(ctx, COLOUR_STRIKE_PRICE, COLOUR_STRIKE_PRICE, COLOUR_STRIKE_PRICE, 1);
        
        //draw strike price
        [self drawText:_strikePrice onCenter:centerLine atLeft:x textSize:strikePriceSize andFont:strikeFont];

        //draw strike
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, strikeOrigin, centerLine + (lineWidth / 2) );
        CGContextAddLineToPoint(ctx, strikeOrigin + strikePriceSize.width, centerLine);
        CGContextStrokePath(ctx);
        
        //move to place to start price
        x+= strikePriceSize.width + PADDING;
        
    }
    
   
    if (![NSString isNilOrEmpty: self.price]) {  //draw the price
        
        if (self.hasDeal /*![NSString isNilOrEmpty: self.strikePrice]*/) {
            CGContextSetRGBFillColor(ctx, COLOUR_PRICE_RED, 0, 0, 1);
        } else {
            CGContextSetRGBFillColor(ctx, COLOUR_PRICE_BLACK, COLOUR_PRICE_BLACK, COLOUR_PRICE_BLACK, 1);
        }
        
        //draw price
        [self drawText:_price onCenter:centerLine atLeft:x textSize:priceSize andFont:priceFont];
        
    }
    

}

- (void) drawText: (NSString *) text onCenter:(float) centerLine atLeft:(float) x textSize:(CGSize) textSize andFont:(UIFont *) font {
   
    float y = centerLine - (textSize.height / 2);
    CGRect rect = CGRectMake(x, y, textSize.width, textSize.height);
    [text drawInRect:rect withFont:font];
}


@end
