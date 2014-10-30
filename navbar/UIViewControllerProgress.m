//
//  UIViewControllerProgress.m
//  Picnics
//
//  Created by Oliver Pearmain on 03/05/2011.
//  Copyright 2011 Compsoft Plc. All rights reserved.
//

#import "UIViewControllerProgress.h"
#import "PicnicsAppDelegate.h"

@implementation UIViewController (Progress)

- (void) showProgressView {
	
	[(PicnicsAppDelegate *)[[UIApplication sharedApplication] delegate] showProgressView];
}
- (void) showProgressViewWithText:(NSString *)text {
	
	[(PicnicsAppDelegate *)[[UIApplication sharedApplication] delegate] showProgressViewWithText:text];
}

- (void) hideProgressView {
	
	[(PicnicsAppDelegate *)[[UIApplication sharedApplication] delegate] hideProgressView];
}

@end

