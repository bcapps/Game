//
//  UITextField+LCKHacks.h
//  Velocity
//
//  Created by Matthew Bischoff on 11/30/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LCKHacks)

/// Fixes a bug in UIKit where the `hasText` methods sometimes returns the string's length instead of a BOOL in iOS 7.0.x.
- (BOOL)actuallyHasText;

@end
