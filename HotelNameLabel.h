//
//  HotelNameLabel.h
//  Venere
//
//  Created by James Tope on 13/12/2012.
//
//

#import <UIKit/UIKit.h>
#define STAR_IMAGE @"StarBlack"
#define PADDING         0

@interface HotelNameLabel : UILabel

@property (nonatomic) NSInteger hotelStarRating;
@property BOOL rightAlignStars;

-(void)update :(NSString*)hotelName andStarRating:(NSInteger) starRating;
-(void)update :(NSString*)hotelName andStarRating:(NSInteger) starRating rightAlignStars:(BOOL)rightAlignStars;

@end
