//
//  UIViewController+UIViewController.m
//  Venere
//
//  Created by John Green on 19/11/2012.
//
//

#import "UIViewController+Extension.h"
#import "Settings.h"

#define BACK_BUTTON_IMAGE @"navbarBackIcon"
#define CALL_BUTTON_IMAGE @"PhoneButton"

@implementation UIViewController (UIViewController)

- (UIBarButtonItem *) addNavigationBackButton:(SEL)actionSelector {

    UIImage *image = [UIImage imageNamed:BACK_BUTTON_IMAGE];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.frame = CGRectMake(0, 0.0, image.size.width + 10, image.size.height);
    [button addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[self.navigationItem setLeftBarButtonItem:buttonItem animated:YES];
    
    return buttonItem;
}



- (UIBarButtonItem *) buildCallBackButton:(SEL)actionSelector {
    
    UIImage *image = [UIImage imageNamed:CALL_BUTTON_IMAGE];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    button.frame = CGRectMake(0, 0.0, image.size.width + 10, image.size.height);
    [button addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonItem;
}

- (UIBarButtonItem *) addCallBackButton:(SEL)actionSelector {
    UIBarButtonItem *buttonItem = [self buildCallBackButton:actionSelector];
	[self.navigationItem setRightBarButtonItem:buttonItem animated:YES];
    return buttonItem;
}


- (void) addGreenBackgroundToNavbarButton:(UIBarButtonItem *) button {
    
    [button setBackgroundImage:[[UIImage imageNamed:@"navbarGreenButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 3, 16, 3)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}

@end
