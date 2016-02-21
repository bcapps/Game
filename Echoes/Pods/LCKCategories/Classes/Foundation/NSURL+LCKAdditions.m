//
//  NSURL+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/5/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "NSURL+LCKAdditions.h"

static NSString * const LCKURLSchemeHTTP = @"http";
static NSString * const LCKURLSchemeHTTPS = @"https";

@implementation NSURL (LCKAdditions)

- (BOOL)isHTTPS {
    return [[self scheme] caseInsensitiveCompare:LCKURLSchemeHTTPS] == NSOrderedSame;
}

- (BOOL)isHTTP {
    return [[self scheme] caseInsensitiveCompare:LCKURLSchemeHTTP] == NSOrderedSame;
}

- (BOOL)isHTTPOrHTTPS {
    return [self isHTTP] || [self isHTTPS];
}

@end
