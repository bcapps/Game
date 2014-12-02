//
//  NSNotificationCenter+LCKAdditions.m
//  Velocity
//
//  Created by Matthew Bischoff on 8/3/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "NSNotificationCenter+LCKAdditions.h"

@implementation NSNotificationCenter (LCKAdditions)

- (void)postNotificationNameOnMainQueue:(NSString *)aName {
    if ([NSThread isMainThread]) {
        [self postNotificationName:aName object:nil];
    }
    else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self postNotificationName:aName object:nil];
        }];
    }
}

@end
