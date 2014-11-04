//
//  ExpandingCellMeta.h
//  Venere
//
//  Created by John Green on 30/10/2013.
//
//


#define EXPANDING_DEFAULT_TEXT_HEIGHT 70

@interface ExpandingCellMeta : NSObject

@property (nonatomic) float maxHeight;
@property (nonatomic) float minHeight;
@property (nonatomic) BOOL isExpanded;
@property (readonly, nonatomic) float height;

- (id) initWithHeight:(float)height;

@end