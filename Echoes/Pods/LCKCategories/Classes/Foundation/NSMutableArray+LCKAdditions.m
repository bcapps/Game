//
//  NSMutableArray+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/9/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "NSMutableArray+LCKAdditions.h"

@implementation NSMutableArray (LCKAdditions)

- (void)safelyAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

@end
