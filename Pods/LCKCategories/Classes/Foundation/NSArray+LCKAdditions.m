//
//  NSArray+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "NSArray+LCKAdditions.h"

@implementation NSArray (LCKAdditions)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (id)firstObjectOfClass:(Class)aClass {
    for (id object in self) {
        if ([object isKindOfClass:aClass]) {
            return object;
        }
    }
    
    return nil;
}

- (NSArray *)objectsOfClass:(Class)aClass {
    NSMutableArray *matchingObjects = [NSMutableArray array];
    
    for (id object in self) {
        if ([object isKindOfClass:aClass]) {
            [matchingObjects addObject:object];
        }
    }
    
    return [matchingObjects copy];
}

- (BOOL)containsObjectOfClass:(Class)aClass {
    if ([self firstObjectOfClass:aClass]) {
        return YES;
    }
    
    return NO;
}

@end
