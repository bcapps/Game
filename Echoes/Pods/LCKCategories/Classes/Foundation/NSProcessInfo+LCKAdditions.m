//
//  NSProcessInfo+LCKAdditions.m
//  Pods
//
//  Created by Matthew Bischoff on 8/31/14.
//
//

#import "NSProcessInfo+LCKAdditions.h"

@implementation NSProcessInfo (LCKAdditions)

+ (NSOperatingSystemVersion)iOS8OperatingSystemVersion {
    NSOperatingSystemVersion iOS8 = { .majorVersion = 8, .minorVersion = 0, .patchVersion = 0 };
    return iOS8;
}

+ (NSOperatingSystemVersion)iOS7_1OperatingSystemVersion {
    NSOperatingSystemVersion iOS7_1 = { .majorVersion = 7, .minorVersion = 1, .patchVersion = 0 };
    return iOS7_1;
}

@end
