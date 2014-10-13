//
//  StarRating.m
//  Venere
//
//  Created by John Green on 15/11/2012.
//
//

#import "StarRating.h"

#define STAR_IMAGE  @"gold-star"
#define PADDING     1

@implementation StarRating

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.ratingValue > 0) {
        UIImage *starImage = [UIImage imageNamed:STAR_IMAGE];
        int x = 0;
        int width = starImage.size.width;
        for (int i = 0; i < self.ratingValue; i++) {
            CGRect imageRect = CGRectMake(x, 0, width, starImage.size.height);
            [starImage drawInRect:imageRect];
            x+= (PADDING + width);
        }
    }
}


@end
