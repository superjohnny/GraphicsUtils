//
//  AppearanceUtils.m
//  Venere
//
//  Created by John Green on 04/11/2013.
//
//

#import "AppearanceUtils.h"

@implementation AppearanceUtils

+ (void) setToolbarAppearance {
    // Set the background image for *all* UINavigationBars
    
    //UIImage *toolbarBackground = [[UIImage imageNamed:@"TabBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[[UIToolbar appearance] setBackgroundImage:toolbarBackground forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
    [[UIToolbar appearance] setBarTintColor:[UIColor blackColor]];
    } else {
        [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    }
}

+ (void) setNavigationBarAppearance {
    //setup appearance on nav bar
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans-Bold" size:20.0], UITextAttributeFont,nil]];
}

+ (void) setBarButtonAppearance {
    //set the bar button items appearance, for ios 7 and later
    
    bool isAboveIOS6 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    if (isAboveIOS6) {
        
        [[UIBarButtonItem appearance] setTitleTextAttributes: [AppearanceUtils barButtonTextAttibutes] forState:UIControlStateNormal];
    }
}

+ (void) setBarButtonAppearanceForButton:(UIBarButtonItem *) barButton {
    [barButton setTitleTextAttributes:[AppearanceUtils barButtonTextAttibutes] forState:UIControlStateNormal];
}

+ (NSDictionary *) barButtonTextAttibutes {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor], UITextAttributeTextColor,
            [UIFont fontWithName:@"OpenSans-Bold" size:16.0f], UITextAttributeFont, [UIColor darkGrayColor], UITextAttributeTextShadowColor, [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)], UITextAttributeTextShadowOffset,
            nil];
}
@end
