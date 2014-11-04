//
//  ExpandingDetailCell.h
//  Venere
//
//  Created by John Green on 15/11/2012.
//
//


#import "ExpandingCellMeta.h"

@class ExpandingDetailCell;


@protocol ExpandingDetailCellDelegate

- (void) didTapExpandingDetailCell:(ExpandingDetailCell *) expandingDetailCell;

@end


@interface ExpandingDetailCell : UITableViewCell <UIGestureRecognizerDelegate>

+ (ExpandingCellMeta *) measureCellHeight:(NSString *)text andTitle:(NSString *) title withWidth:(float) width andDefaultMinHeight:(float)defaultMinHeight;

@property (assign, nonatomic) id<ExpandingDetailCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIView *expandingContainer;
@property (weak, nonatomic) IBOutlet UILabel *expandingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;



- (void) updateWithText:(NSString *) text andTitle:(NSString *) title;
- (void) updateWithMeta:(ExpandingCellMeta *)expandingCellMeta;

@end
