//
//  LCKAccessibilityContainerView.m
//  Pods
//
//  Created by Andrew Harrison on 5/22/14.
//
//

#import "LCKAccessibilityContainerView.h"

@implementation LCKAccessibilityContainerView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _accessibilityViews = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)accessibleElements {
    return self.accessibilityViews;
}

@end
