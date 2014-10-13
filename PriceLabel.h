//
//  PriceLabel.h
//  Venere
//
//  Created by John Green on 19/11/2012.
//
//

#import "HotelSearchResult.h"


@interface PriceLabel : UILabel

- (void) update:(NSString *) withPrice andStrikePrice:(NSString *) strikePrice andHasDeal:(BOOL) hasDeal;

@end
