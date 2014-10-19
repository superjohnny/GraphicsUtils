//
//  NSString+Extension.h
//  Venere
//
//  Created by John Green on 11/12/2012.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/*!
 * @discussion
 * Returns true if string is nil or empty.
 */
+ (BOOL)isNilOrEmpty:(NSString *)input;


/*!
 * @discussion
 * If the value is nil then return an empty string. Otherwise return the value
 * This is useful for NSString stringWithFormat, preventing a nil values causing (null) to be displayed.
 */
+ (NSString *) emptyIfNil: (NSString *) input;



/*!
 * @discussion
 * Trims whitespace and commas from the ends of given string
 */
+ (NSString *) trimmed:(NSString *) input;

- (NSString *) trimmed;

- (float) heightForWidth: (int) width andFont:(UIFont *) font;

- (float) widthInFont:(UIFont *) font;

@end
