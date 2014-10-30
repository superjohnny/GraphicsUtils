//
//  UIViewController+UIViewController.h
//  Venere
//
//  Created by John Green on 19/11/2012.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController)

- (UIBarButtonItem *) addNavigationBackButton:(SEL)actionSelector;

- (UIBarButtonItem *) buildCallBackButton:(SEL)actionSelector;
- (UIBarButtonItem *) addCallBackButton:(SEL)actionSelector;

- (void) addGreenBackgroundToNavbarButton:(UIBarButtonItem *) button;

@end
