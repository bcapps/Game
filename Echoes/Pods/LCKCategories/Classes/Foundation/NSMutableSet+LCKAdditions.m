//
//  NSMutableSet+LCKAdditions.m
//  Pods
//
//  Created by Matthew Bischoff on 6/21/14.
//
//

#import "NSMutableSet+LCKAdditions.h"

@implementation NSMutableSet (LCKAdditions)

- (void)safelyAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

@end
