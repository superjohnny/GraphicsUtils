//
//  SlideUpSheet.h
//  Venere
//
//  Created by John Green on 14/12/2012.
//
//

#import <UIKit/UIKit.h>

@class SlideUpSheet;

enum SlideUpSheetDismissedBy {
    SlideUpSheetDismissedByLeftButton,
    SlideUpSheetDismissedByRightButton
    };

@protocol SlideUpSheetDelegate<NSObject>

- (void) didDismissSlideUpSheet:(SlideUpSheet *) slideUpSheet dismissedBy:(enum SlideUpSheetDismissedBy) dismissedBy;

@optional

- (void) previousButtonPressedSlideUpSheet:(SlideUpSheet *) slideUpSheet withSubView:(UIView *)subview;
- (void) nextButtonPressedSlideUpSheet:(SlideUpSheet *) slideUpSheet withSubView:(UIView *)subview;

@end

@interface SlideUpSheet : UIView

@property (weak, nonatomic) UIView *subview;

@property (weak, nonatomic) id<SlideUpSheetDelegate> delegate;

- (id) initWithPresentInView:(UIView *) presentInView andRightButtonTitle:(NSString *) rightButtonTitle andLeftButtonTitle:(NSString *) leftButtonTitle andSubview:(UIView *) subview;
- (id) initWithPresentInView:(UIView *) presentInView andPreviousButtonTitle:(NSString *) previousButtonTitle andNextButtonTitle:(NSString *) nextButtonTitle andDoneButtonTitle:(NSString *) DoneButtonTitle andSubview:(UIView *) subview;
- (id) initWithPresentInView:(UIView *) presentInView withUIBarButtonItems:(NSArray *)uiBarButtonItems andSubview:(UIView *) subview;

- (void) slideUp;
- (void) dismissSlideUp;

@end
