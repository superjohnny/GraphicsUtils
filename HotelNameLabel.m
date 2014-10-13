//
//  HotelNameLabel.m
//  Venere
//
//  Created by James Tope on 13/12/2012.
//
//

#import "HotelNameLabel.h"

@implementation HotelNameLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Draws the Hotel name followed by the relevant number of stars.
    // If insufficient space, the name truncates but the stars are always drawn
    
    int availableWidth = rect.size.width;
    
    UIImage *scaledImage = [UIImage imageNamed:STAR_IMAGE];
    
    int starWidth = scaledImage.size.width;
    int starsTotalWidth = /*PADDING + */ ((starWidth + PADDING) * self.hotelStarRating);
    
    CGSize textSize = [self.text sizeWithFont:self.font];
    
    int textAvailableWidth = availableWidth - starsTotalWidth;
    
    int drawTextToWidth;
    if (textSize.width > textAvailableWidth) {
        drawTextToWidth = textAvailableWidth;
    } else {
        drawTextToWidth = textSize.width;
    }
    
     int x = 0;
    
    [self.text drawInRect:CGRectMake(x, rect.origin.y, drawTextToWidth, textSize.height) withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (_rightAlignStars) {
        x = (availableWidth - starsTotalWidth) + PADDING;
    } else {
        x += (drawTextToWidth + PADDING);
    }
    
    
    for (int i = 0; i < self.hotelStarRating; i++) {
        CGRect imageRect = CGRectMake(x, (textSize.height - scaledImage.size.height) / 2, scaledImage.size.width, scaledImage.size.height);
        [scaledImage drawInRect:imageRect];
        x+= PADDING + starWidth;            
        
    }

}


-(void)update :(NSString*)hotelName andStarRating:(NSInteger) starRating
{
    self.text = hotelName;
    self.hotelStarRating = starRating;
    
    [self setNeedsDisplay];
}

-(void)update :(NSString*)hotelName andStarRating:(NSInteger) starRating rightAlignStars:(BOOL)rightAlignStars
{
    _rightAlignStars = rightAlignStars;
    
    [self update:hotelName andStarRating:starRating];
}


@end
