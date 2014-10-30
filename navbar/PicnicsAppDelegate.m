//
//  PicnicsAppDelegate.m
//  Picnics
//
//  Created by Simon NR Burfield on 22/03/2011.
//  Copyright 2011 Compsoft Plc. All rights reserved.
//

#import "PicnicsAppDelegate.h"
#import "MainMenu.h"
#import <Three20/Three20.h>
#import "GalleryViewController.h"

@implementation PicnicsAppDelegate
@synthesize popupButton;


@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize serviceTimer;
@synthesize progressView;
@synthesize progressViewLabel;
@synthesize splashView;
@synthesize movie;
@synthesize popupView, popupScrollView, popupImageView, popupTitleLabel, popupTextLabel, onPopupClose, onPopupButtonClick;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
	progressView.hidden = YES;
    [self.window addSubview:progressView];
    [self.window addSubview:splashView];
    
    [PicnicEntities initialize];
    
    [Service startDetectingNetworkChanges];
    
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.URLMap from:@"tt://picnicSpotPhotos/(initWithPicnicSpotId:)/(startAtIndex:)/(isSharedSpot:)" toSharedViewController:[GalleryViewController class]];
    [navigator.URLMap from:@"tt://favouritePhotos/(initWithFavourites:)" toSharedViewController:[GalleryViewController class]];
    
	[self loadSplashVideo];
	[self performSelector: @selector(fadeSplash) withObject:nil afterDelay:3.5];
	
    [self createServiceTimer];
    
    return YES;
}

- (void)fadeSplash 
{
	if(splashView != nil)
	{
        splashView.alpha = 1.0f;
        [UIView beginAnimations:@"fadeOutSplash" context:NULL];
        [UIView setAnimationDuration:0.7];
        splashView.alpha = 0.0f;
        splashView = nil;
		[movie stop];
		self.movie = nil;
        [UIView commitAnimations];
	}
}

- (void)loadSplashVideo {
	
	NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"SplashMovie" ofType:@"mov"];
	NSURL *url = [NSURL fileURLWithPath:urlStr];
	MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
	mp.shouldAutoplay = NO;
	mp.repeatMode = MPMovieRepeatModeNone;
	self.movie = mp;
	[mp release];
    
	movie.controlStyle = MPMovieControlStyleNone;
	movie.scalingMode = MPMovieScalingModeFill;
	movie.view.frame = CGRectMake(0, 0, 320, 460);
    movie.view.backgroundColor = [UIColor clearColor];
	
	[movie prepareToPlay];
	[self.splashView addSubview:movie.view];
	[movie play];
}

- (IBAction)removeSplash 
{
	if(splashView != nil)
	{
        splashView.alpha = 1.0f;
        [UIView beginAnimations:@"fadeOutSplash" context:NULL];
        [UIView setAnimationDuration:0.7];
        splashView.alpha = 0.0f;
        splashView = nil;
        [UIView commitAnimations];
        //[splashView removeFromSuperview];
        //splashView = nil;
	}
}


- (void)timerTick: (NSTimer *)timer {
	[Service timerTick];
}

- (void) createServiceTimer {
	if (self.serviceTimer == nil) {
		self.serviceTimer = [NSTimer scheduledTimerWithTimeInterval:[Settings getPollServerEveryXSeconds] target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
	}
}

- (void) stopServiceTimer {
	if (self.serviceTimer != nil) {
		[self.serviceTimer invalidate];
		self.serviceTimer = nil;
	}
}

- (void) showProgressView {
    [self showProgressViewWithText:@"Please Wait ..."];
}

- (void) showProgressViewWithText:(NSString *)text {
    self.progressViewLabel.text = text;
    self.progressView.alpha = 0.0;
	self.progressView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.progressView.alpha = 1.0;
    }];
}

- (void) hideProgressView {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         self.progressView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         progressView.hidden = YES;
                     }];
}

- (IBAction)closePopup {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         self.popupView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.popupView removeFromSuperview];
                         self.onPopupButtonClick = nil;
                         if (self.onPopupClose) {
                             self.onPopupClose();
                             self.onPopupClose = nil;
                         }
                     }];
}

- (IBAction)popupButtonClicked:(id)sender {
    if (self.onPopupButtonClick)
        self.onPopupButtonClick();
    [self closePopup];
}

- (void)showPopup:(UIImage *)popupImage {
    [self showPopup:popupImage onClose:nil];
}

- (void)showPopup:(UIImage *)popupImage onClose:(void (^)(void))onClose {
    [self showPopup:popupImage onClose:onClose withButtonAt:CGRectNull onClick:nil];
}

- (void)showPopup:(UIImage *)popupImage withButtonAt:(CGRect)frame onClick:(void (^)(void))onClick {
    [self showPopup:popupImage onClose:nil withButtonAt:frame onClick:onClick];
}

- (void)showPopup:(UIImage *)popupImage onClose:(void (^)(void))onClose withButtonAt:(CGRect)frame onClick:(void (^)(void))onClick {
    self.onPopupClose = onClose;
    [self.popupTitleLabel setHidden:YES];
    [self.popupTextLabel setHidden:YES];
    [self.popupImageView setHidden:NO];
    
    [popupImageView setImage:popupImage];
    CGSize imageSize = [popupImage size];
    [popupImageView setFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [popupScrollView setContentSize:CGSizeMake([popupScrollView contentSize].width, imageSize.height)];
    [popupScrollView setContentOffset:CGPointMake(0, 0)];
    
    self.popupButton.frame = frame;
    self.onPopupButtonClick = onClick;
    
    [self.window addSubview:self.popupView];
    self.popupView.alpha = 0.0;
    self.popupView.hidden = false;
    [UIView animateWithDuration:0.25
                     animations:^(void) {
                         self.popupView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [popupScrollView flashScrollIndicators];
                     }];
}

- (void)showPopup:(NSString *)popupTitle withText:(NSString *)popupText {
    [self showPopup:popupTitle withText:popupText onClose:nil];
}

- (void)showPopup:(NSString *)popupTitle withText:(NSString *)popupText onClose:(void (^)(void))onClose {
    self.onPopupClose = onClose;
    [self.popupTitleLabel setHidden:NO];
    [self.popupTextLabel setHidden:NO];
    [self.popupImageView setHidden:YES];
    
    [self.popupTitleLabel setText:popupTitle];
    [self.popupTextLabel setText:popupText];
    [self.popupTextLabel sizeToFit];
    self.popupTextLabel.textColor = [UIColor whiteColor];
    CGFloat height = self.popupTextLabel.frame.origin.y + self.popupTextLabel.frame.size.height;
    [self.popupScrollView setContentSize:CGSizeMake([popupScrollView contentSize].width, height)];
    
    [self.window addSubview:self.popupView];
    self.popupView.alpha = 0.0;
    self.popupView.hidden = false;
    [UIView animateWithDuration:0.25
                     animations:^(void) {
                         self.popupView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [popupScrollView flashScrollIndicators];
                     }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[Service stopDetectingNetworkChanges];
	
	[self stopServiceTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	[Service stopDetectingNetworkChanges];
	
	[self stopServiceTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
	[Service startDetectingNetworkChanges];
	
	[self createServiceTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[Service startDetectingNetworkChanges];
	
	[self createServiceTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    
	[Service stopDetectingNetworkChanges];
	
	[self stopServiceTimer];
}


- (void)dealloc
{
    [_window release];
    [_navigationController release];
	[movie release];
    [popupButton release];
    [super dealloc];
}

+ (NSString *)loadTermsAndConditionsText {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"terms_conditions" ofType:@"txt"];
    NSError *err = nil;
    NSString *tnc = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&err];
    return tnc;
}

@end
