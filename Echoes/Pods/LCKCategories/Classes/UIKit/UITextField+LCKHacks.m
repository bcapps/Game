//
//  UITextField+LCKHacks.m
//  Velocity
//
//  Created by Matthew Bischoff on 11/30/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UITextField+LCKHacks.h"

@implementation UITextField (LCKHacks)

- (BOOL)actuallyHasText {
    BOOL hasText = NO;
    if ([self hasText]) {
        hasText = YES;
    }
    return hasText;
}

@end
