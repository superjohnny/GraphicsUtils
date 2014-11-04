//
//  PullDownRefresh.m
//  Card Room Magic
//
//  Created by John Green on 08/08/2012.
//  Copyright (c) 2012 Compsoft. All rights reserved.
//

#import "PullDownRefresh.h"


#define TEXT_COLOUR             [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
#define BACKGROUND_COLOUR       [UIColor colorWithWhite:0.0 alpha:0.5]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"CRM_background"]] [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:0.8];
#define ANIMATION_DURATION      0.18f


@interface PullDownRefresh ()
@property (nonatomic) PullDownRefreshEnum state;
@property (strong, nonatomic) NSString *pullingTitle;
@property (strong, nonatomic) NSString *idleTitle;
@property (strong, nonatomic) NSString *updatingTitle;
@end


@implementation PullDownRefresh {
	PullDownRefreshEnum _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = BACKGROUND_COLOUR;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOUR;
		//label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
        
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:14.0f];
		label.textColor = TEXT_COLOUR;
		//label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		[self addSubview:label];
		_statusLabel=label;
		
		
//        float scale = [self contentScaleFactor];
        CGRect imageFrame = CGRectMake(frame.size.width/2 - 15, frame.size.height - 65.0f, 30.0f, 55.0f);
        
		CALayer *layer = [CALayer layer];
        layer.frame = imageFrame;
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"UpdateArrow"].CGImage;
		layer.contentsScale = [self contentScaleFactor];

//        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//        
        
        
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		view.frame = CGRectMake(frame.size.width/2 - 18, frame.size.height - 46.0f, 36.0f, 36.0f);
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:PullDownIdle];
    }
    
    return self;
}



#pragma mark --
#pragma mark Methods

- (void)refreshLastUpdatedDate {
	
    //--
    
	if (delegate != nil) {
		
		NSDate *date = [delegate pullDownRefreshDataSourceLastUpdated:self];
		
        if (date == nil) return;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Updated: %@", [formatter stringFromDate:date]];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"PullDownRefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(PullDownRefreshEnum)newState{
	
	switch (newState) {
		case PullDownPulling:
			
			//_statusLabel.text = self.pullingTitle;
			[CATransaction begin];
			[CATransaction setAnimationDuration:ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case PullDownIdle:
			
			if (_state == PullDownPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			//_statusLabel.text = self.idleTitle;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case PullDownRefreshing:
			
            //_statusLabel.text = self.updatingTitle;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = newState;
}

#pragma mark - Methods

- (NSString *) pullingTitle {
    if (self.delegate)
        return [delegate pullDownRefreshPullingTitle:self];

    return NSLocalizedString(@"Release to update...", @"Release to update status");
}

- (NSString *) idleTitle {
    if (self.delegate)
        return [delegate pullDownRefreshIdleTitle:self];

    return NSLocalizedString(@"Pull to update...", @"Pull down to update status");
}

- (NSString *) updatingTitle {
    if (self.delegate)
        return [delegate pullDownRefreshUpdatingTitle:self];

    return NSLocalizedString(@"Updating...", @"Updating Status");
}



#pragma mark Protocol Methods

- (void) pullDownRefreshDidScroll:(UIScrollView *)scrollView {
    if (_state == PullDownRefreshing) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL loading = NO;
        
		if (delegate != nil) {
			loading = [delegate pullDownRefreshDataSourceIsLoading:self];
		}
		
		if (_state == PullDownPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
			[self setState:PullDownIdle];
		} else if (_state == PullDownIdle && scrollView.contentOffset.y < -65.0f && !loading) {
			[self setState:PullDownPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
}

- (void) pullDownRefreshDidEndPulling:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if (delegate != nil) {
		_loading = [delegate pullDownRefreshDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if (delegate != nil) {
			[delegate pullDownRefreshDidTriggerRefresh:self];
		}
		
		[self setState:PullDownRefreshing];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
}

- (void) pullDownRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:PullDownIdle];
    
}

- (void) pullDownRefreshShowUpdating: (UIScrollView *) scrollView {
    [self setState:PullDownRefreshing];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void) pullDownRefreshHideUpdating: (UIScrollView *) scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:PullDownIdle];
}


@end
