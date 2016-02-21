//
//  NSHTTPURLResponse+LCKAdditions.m
//  Velocity
//
//  Created by Matthew Bischoff on 8/3/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "NSHTTPURLResponse+LCKAdditions.h"

@implementation NSHTTPURLResponse (LCKAdditions)

- (BOOL)isSuccessful {
    return [[[self class] successfulStatusCodes] containsIndex:[self statusCode]];
}

+ (NSIndexSet *)successfulStatusCodes {
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
}

@end
