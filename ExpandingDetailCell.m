//
//  ExpandingDetailCell.m
//  Venere
//
//  Created by John Green on 15/11/2012.
//
//

#import "ExpandingDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+Extension.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "UIView+Animation.h"

#define DEFAULT_MIN_HEIGHT      33
#define EXPANDED_IMAGE          @"DisclosureArrow_Grey"
#define ANIMATION_DURATION      0.25f
#define BOTTOM_PADDING          5


#define H_PADDING 15
#define W_PADDING 20



@implementation ExpandingDetailCell {
    CALayer *_indicatorImage;
}

static UIFont *_fontTitle = nil;
static UIFont *_font = nil;


+ (ExpandingCellMeta *) measureCellHeight:(NSString *)text andTitle:(NSString *) title withWidth:(float) width andDefaultMinHeight:(float)defaultMinHeight {
    //find height of cell for font
    
    ExpandingCellMeta *cellMetaData = [[ExpandingCellMeta alloc] init];
    
    width -= W_PADDING;
    width -= W_PADDING;
    
    float textHeight = [text heightForWidth:width andFont:_font];
    textHeight += [title heightForWidth:255 andFont:_fontTitle];
    
    textHeight += H_PADDING;
    textHeight += H_PADDING;
    
    if (textHeight > defaultMinHeight) {
        cellMetaData.minHeight = defaultMinHeight + H_PADDING + H_PADDING;
        cellMetaData.maxHeight = textHeight;
    }else{
        cellMetaData.minHeight = textHeight;
        cellMetaData.maxHeight = textHeight;
    }
    return cellMetaData;
}

+ (void) initialize {
    if (self == [ExpandingDetailCell class] ) {
        _fontTitle = [UIFont fontWithName:@"OpenSans" size:13];
        _font = [UIFont fontWithName:@"OpenSans" size:12];
    }
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)];
        
        [self.contentView addGestureRecognizer:tap];
        
        CALayer *layer = [CALayer layer];
        //layer.frame = self.iconImage.frame;
        layer.frame = CGRectMake(290, 20, 14, 9);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:EXPANDED_IMAGE].CGImage;
        [[self.contentView layer] addSublayer:layer];
        _indicatorImage = layer;
    }
    return self;
}

#pragma mark - Public Methods

- (void) updateWithText:(NSString *) text andTitle:(NSString *) title {

    self.headingLabel.text = title;
    self.expandingLabel.text = text;
    
    self.headingLabel.font = _fontTitle;
    self.expandingLabel.font = _font;
    
    [self.headingLabel moveTop:H_PADDING];
    [self.expandingLabel moveTop:[self.headingLabel bottom]];

}

- (void)updateWithMeta:(ExpandingCellMeta *)expandingCellMeta
{
    float heightForLabel = expandingCellMeta.height;
    heightForLabel -= H_PADDING;
    heightForLabel -= H_PADDING;
    
    float titleHeight = [self.headingLabel.text heightForWidth:255 andFont:self.headingLabel.font];
    [self.headingLabel resizeHeight:titleHeight];
    heightForLabel -= titleHeight;
    
    [self.expandingContainer moveTop: [self.headingLabel bottom]];
    [self.expandingLabel moveTop:0];
    
   
    if (expandingCellMeta.isExpanded) {
        //grow
        [self.expandingLabel resizeHeight:heightForLabel];
        [self.expandingContainer growDown:heightForLabel forAnimationDuration:ANIMATION_DURATION withCompletionBlock:nil];
    } else {
        //shrink
        [self.expandingContainer growDown:heightForLabel forAnimationDuration:ANIMATION_DURATION withCompletionBlock:^{
            [self.expandingLabel resizeHeight:heightForLabel];
        }];
    }

    //animate the icon
    if (expandingCellMeta.isExpanded) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:ANIMATION_DURATION];
        _indicatorImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 269.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
    } else {
        [CATransaction begin];
        //[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        //_indicatorImage.transform = CATransform3DIdentity;
        [CATransaction setAnimationDuration:ANIMATION_DURATION];
        _indicatorImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
    }
    
    
    DLog(@"%@", NSStringFromCGRect(self.expandingLabel.frame));
}


#pragma mark - Private Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}

-(void) didTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate != nil)
        [self.delegate didTapExpandingDetailCell:self];
}
@end
