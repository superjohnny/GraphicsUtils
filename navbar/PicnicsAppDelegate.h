//
//  PicnicsAppDelegate.h
//  Picnics
//
//  Created by Simon NR Burfield on 22/03/2011.
//  Copyright 2011 Compsoft Plc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PicnicsAppDelegate : NSObject <CLLocationManagerDelegate, UIApplicationDelegate> {

    NSTimer *serviceTimer;
	MPMoviePlayerController *movie;
    void (^onPopupClose)(void);
    UIButton *popupButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSTimer *serviceTimer;
@property (nonatomic, retain) IBOutlet UIView *progressView;
@property (nonatomic, retain) IBOutlet UILabel *progressViewLabel;
@property (nonatomic, retain) IBOutlet UIView *splashView;
@property (nonatomic, retain) MPMoviePlayerController *movie;

@property (nonatomic, retain) IBOutlet UIView *popupView;
@property (nonatomic, retain) IBOutlet UIScrollView *popupScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *popupImageView;
@property (nonatomic, retain) IBOutlet UILabel *popupTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *popupTextLabel;
@property (nonatomic, retain) IBOutlet UIButton *popupButton;
- (IBAction)popupButtonClicked:(id)sender;
@property (nonatomic, copy) void (^onPopupClose)(void);
@property (nonatomic, copy) void (^onPopupButtonClick)(void);

- (IBAction)fadeSplash;
- (IBAction)removeSplash;

- (void)loadSplashVideo;

- (void) createServiceTimer;
- (void) stopServiceTimer;

- (void) showProgressView;
- (void) showProgressViewWithText:(NSString *)text;
- (void) hideProgressView;

- (IBAction)closePopup;
- (void)showPopup:(UIImage *)popupImage;
- (void)showPopup:(UIImage *)popupImage onClose:(void (^)(void))onClose;
- (void)showPopup:(UIImage *)popupImage withButtonAt:(CGRect)frame onClick:(void (^)(void))onClick;
- (void)showPopup:(UIImage *)popupImage onClose:(void (^)(void))onClose withButtonAt:(CGRect)frame onClick:(void (^)(void))onClick;
- (void)showPopup:(NSString *)popupTitle withText:(NSString *)popupText;
- (void)showPopup:(NSString *)popupTitle withText:(NSString *)popupText onClose:(void (^)(void))onClose;

+ (NSString *)loadTermsAndConditionsText;

@end
