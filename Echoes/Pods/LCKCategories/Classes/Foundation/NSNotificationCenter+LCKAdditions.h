//
//  NSNotificationCenter+LCKAdditions.h
//  Velocity
//
//  Created by Matthew Bischoff on 8/3/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (LCKAdditions)
- (void)postNotificationNameOnMainQueue:(NSString *)aName;
@end
