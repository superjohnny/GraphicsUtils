//
//  ScarcityLabel.m
//  Venere
//
//  Created by John Green on 10/07/2013.
//
//

#import "ScarcityLabel.h"

#define WARNING_ICON  @"TimeWarningIcon"
#define PADDING 3

@implementation ScarcityLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGSize textSize = [self.text sizeWithFont:self.font];
    UIImage *img = [UIImage imageNamed:WARNING_ICON];
    
    int x = 0;
    
    //find the aligment of the text
    if (self.textAlignment == UITextAlignmentLeft)
        x = textSize.width + PADDING;
    else
        x = self.bounds.size.width - textSize.width - img.size.width - PADDING;
    
    //draw the img in the right place
    [img drawAtPoint:CGPointMake(x, (rect.size.height - img.size.height) / 2)];
    
    [super drawRect:rect];
}


@end
