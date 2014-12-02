//
//  UIScrollView+LCKAddtions.m
//  Velocity
//
//  Created by Andrew Harrison on 8/31/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UIScrollView+LCKAddtions.h"

@implementation UIScrollView (LCKAddtions)

- (void)stopScrolling {
    if ([self isScrolling]) {
        NSInteger offsetValue = 1;
        
        [self setContentOffset:CGPointMake(self.contentOffset.x - offsetValue, self.contentOffset.y - offsetValue) animated:NO];
        
        [self setContentOffset:CGPointMake(self.contentOffset.x + offsetValue, self.contentOffset.y + offsetValue) animated:NO];
    }
}

- (BOOL)isScrolling {
    return self.isTracking || self.isDragging || self.isDecelerating;
}

@end
