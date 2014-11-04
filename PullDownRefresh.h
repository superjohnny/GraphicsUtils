//
//  PullDownRefresh.h
//  Card Room Magic
//
//  Created by John Green on 08/08/2012.
//  Copyright (c) 2012 Compsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum { PullDownPulling, PullDownIdle, PullDownRefreshing} PullDownRefreshEnum;


@class PullDownRefresh;

@protocol PullDownRefreshDelegate
- (void) pullDownRefreshDidTriggerRefresh: (PullDownRefresh *)view;
- (BOOL) pullDownRefreshDataSourceIsLoading:(PullDownRefresh*)view;
- (NSDate *) pullDownRefreshDataSourceLastUpdated:(PullDownRefresh*)view;
- (NSString *) pullDownRefreshPullingTitle: (PullDownRefresh *)view;
- (NSString *) pullDownRefreshIdleTitle: (PullDownRefresh *)view;
- (NSString *) pullDownRefreshUpdatingTitle: (PullDownRefresh *)view;
@end


@interface PullDownRefresh : UIView {}

@property (nonatomic, assign) id<PullDownRefreshDelegate> delegate;

- (void) pullDownRefreshDidScroll:(UIScrollView *)scrollView;
- (void) pullDownRefreshDidEndPulling:(UIScrollView *)scrollView;
- (void) pullDownRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void) pullDownRefreshShowUpdating: (UIScrollView *) scrollView;
- (void) pullDownRefreshHideUpdating: (UIScrollView *) scrollView;

@end
