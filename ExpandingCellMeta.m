//
//  ExpandingCellMeta.m
//  Venere
//
//  Created by John Green on 30/10/2013.
//
//

#import "ExpandingCellMeta.h"

@implementation ExpandingCellMeta

- (id) initWithHeight:(float)height
{
    self = [super init];
    if (self){
        self.minHeight = height;
        self.maxHeight = height;
        self.isExpanded = NO;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f, %f, %@", self.minHeight, self.maxHeight, (self.isExpanded ? @"YES" : @"NO")];
}

- (float)height
{
    return self.isExpanded ? self.maxHeight : self.minHeight;
}

@end

