//
//  UIDevice+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//
//

@interface UIDevice (LCKAdditions)

/// Returns YES if the current device is using the UIUserInterfaceIdiomPhone
+ (BOOL)isiPhone;

/// Returns YES if the current device is using the UIUserInterfaceIdiomPad
+ (BOOL)isiPad;

@end
