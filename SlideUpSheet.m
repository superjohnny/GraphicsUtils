//
//  SlideUpSheet.m
//  Venere
//
//  Created by John Green on 14/12/2012.
//
//

#import "SlideUpSheet.h"
#import "UIView+Animation.h"
#import "UIView+Extension.h"
#import "UISegmentedControl+Extension.h"


#define ANIMATION_DURATION 0.3
#define OBSCURE_ALPHA 0.3

@implementation SlideUpSheet {
    UIView *slideUpView;
    UIView *obscureView;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
}
@synthesize delegate;


- (id) initWithPresentInView:(UIView *) presentInView andRightButtonTitle:(NSString *) rightButtonTitle andLeftButtonTitle:(NSString *) leftButtonTitle andSubview:(UIView *) subview {
    
    NSMutableArray *items = [NSMutableArray new];
    if (leftButtonTitle) {
        leftButton = [[UIBarButtonItem alloc] initWithTitle:leftButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSlideUp:)];
        [items addObject:leftButton];
    }
    UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexiSpace];
    
    if (rightButtonTitle) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:/*UIBarButtonItemStyleBordered*/ UIBarButtonItemStyleDone target:self action:@selector(dismissSlideUp:)];
        [items addObject:rightButton];
    }
    
    self = [self initWithPresentInView:presentInView withUIBarButtonItems:items andSubview:subview];
    if (self) {
        //
    }
    
    return self;
}

- (id) initWithPresentInView:(UIView *) presentInView andPreviousButtonTitle:(NSString *) previousButtonTitle andNextButtonTitle:(NSString *) nextButtonTitle andDoneButtonTitle:(NSString *) doneButtonTitle andSubview:(UIView *) subview {
    
    NSMutableArray *items = [NSMutableArray new];

    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[previousButtonTitle, nextButtonTitle]];
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.momentary = YES;
    
    [control fixForiOS7];
    
    [control addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segmentedControl = [[UIBarButtonItem alloc] initWithCustomView:control];
    [items addObject:segmentedControl];
    
    
    UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexiSpace];
    
    if (doneButtonTitle) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(dismissSlideUp:)];
        [items addObject:rightButton];
    }
    
    self = [self initWithPresentInView:presentInView withUIBarButtonItems:items andSubview:subview];
    if (self) {
        //
    }
    
    return self;
}
                                         
 - (void)nextPrevious:(UISegmentedControl *)previousNextSegmentedControl {
     if (previousNextSegmentedControl.selectedSegmentIndex == 0) {
         if ([self.delegate respondsToSelector:@selector(previousButtonPressedSlideUpSheet:withSubView:)])
             [self.delegate previousButtonPressedSlideUpSheet:self withSubView:self.subview];
     }
     else {
         if ([self.delegate respondsToSelector:@selector(nextButtonPressedSlideUpSheet:withSubView:)])
             [self.delegate nextButtonPressedSlideUpSheet:self withSubView:self.subview];
     }   
 }

- (id) initWithPresentInView:(UIView *) presentInView withUIBarButtonItems:(NSArray *)uiBarButtonItems andSubview:(UIView *) subview {
    CGRect frame = presentInView.superview.frame;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.subview = subview;
        
        self.backgroundColor = [UIColor clearColor]; //hide this view
        self.frame = frame;
        
        //add a smoked view to obscure the underlying views
        obscureView = [[UIView alloc] initWithFrame:frame];
        obscureView.backgroundColor = [UIColor blackColor];
        obscureView.alpha = 0;
        obscureView.hidden = YES;
        [self addSubview:obscureView];
        
        //add and offscreen slide up view, to slide up
        CGRect slideUpframe = CGRectMake(0, frame.size.height /*off bottom of screen*/, frame.size.width, frame.size.height);
        slideUpView = [[UIView alloc] initWithFrame:slideUpframe];
        
        if (uiBarButtonItems && uiBarButtonItems.count > 0) {
            UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            
            [toolbar setBarStyle:UIBarStyleBlackTranslucent];
            [toolbar setItems:uiBarButtonItems];
            [subview moveTop:[toolbar bottom]];
            [slideUpView addSubview:toolbar];
            [slideUpView addSubview:subview];
            [slideUpView resizeHeight:toolbar.frame.size.height + subview.frame.size.height];
        }
        
        [self addSubview:slideUpView];
        
        //add to view to present in
        [presentInView addSubview:self];
        
    }
    return self;

}

- (void) slideUp {
    [obscureView fadeIn:ANIMATION_DURATION toAlpha:OBSCURE_ALPHA];
    [slideUpView slideUp:ANIMATION_DURATION];
}

- (void) dismissSlideUp:(UIBarButtonItem *) button {
    
    enum SlideUpSheetDismissedBy dismissBy = SlideUpSheetDismissedByLeftButton;
    if ([button isEqual: rightButton])
        dismissBy = SlideUpSheetDismissedByRightButton;
        
    if (self.delegate)
        [self.delegate didDismissSlideUpSheet:self dismissedBy:dismissBy];
    
    [obscureView fadeOut:ANIMATION_DURATION];
    [slideUpView slideDown:ANIMATION_DURATION withCompletionBlock:^{
        [self removeFromSuperview];
    }];
    
}

- (void) dismissSlideUp
{
    [obscureView fadeOut:ANIMATION_DURATION];
    [slideUpView slideDown:ANIMATION_DURATION withCompletionBlock:^{
        [self removeFromSuperview];
    }];
}


//might need this for ios7 button backgrounds
-(UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
