//
//  NSString+Extension.m
//  Venere
//
//  Created by John Green on 11/12/2012.
//
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


+ (BOOL) isNilOrEmpty:(NSString *) input {
    return ((input == nil) || [input isEqualToString:@""]);
}

+ (NSString *) emptyIfNil:(NSString *) input {
    return input == nil ? @"" : input;
}

+ (NSString *) trimmed:(NSString *) input {
    NSString *trimmedString = [input stringByTrimmingCharactersInSet:
                                /*[NSCharacterSet whitespaceCharacterSet]*/ [NSCharacterSet characterSetWithCharactersInString:@", "]];
    return trimmedString;
}

- (NSString *) trimmed {
    return [NSString trimmed:self];
}

//- (BOOL) isNilOrEmpty {
//    return ((self == nil) || [self isEqualToString:@""]);
//}

- (float) heightForWidth: (int) width andFont:(UIFont *) font {
    
    //support for ios6 & 7
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:self
         attributes:@{ NSFontAttributeName: font }];
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return ceil(rect.size.height);
    }
    
    
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (float) widthInFont:(UIFont *) font {
    //support for ios6 & 7
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:self
         attributes:@{ NSFontAttributeName: font }];
        

        CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, font.lineHeight}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        return ceil(rect.size.width);
    }
    
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight)].width;
}

@end
