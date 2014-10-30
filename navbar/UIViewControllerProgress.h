//
//  UIViewControllerProgress.h
//  Picnics
//
//  Created by Oliver Pearmain on 03/05/2011.
//  Copyright 2011 Compsoft Plc. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UIViewController (Progress)

- (void) showProgressView;
- (void) showProgressViewWithText:(NSString *)text;
- (void) hideProgressView;

@end

