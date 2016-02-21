//
//  NSProcessInfo+LCKAdditions.h
//  Pods
//
//  Created by Matthew Bischoff on 8/31/14.
//
//

@import Foundation;

extern bool NSOperatingSystemVersionEqualsVersion(NSOperatingSystemVersion version1, NSOperatingSystemVersion version2);

@interface NSProcessInfo (LCKAdditions)

/// Returns an NSOperatingSystemVersion represeting iOS 8.0.0.
+ (NSOperatingSystemVersion)iOS8OperatingSystemVersion;

/// Returns an NSOperatingSystemVersion represeting iOS 7.1.0.
+ (NSOperatingSystemVersion)iOS7_1OperatingSystemVersion;

@end
