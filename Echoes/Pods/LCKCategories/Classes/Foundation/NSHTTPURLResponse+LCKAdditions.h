//
//  NSHTTPURLResponse+LCKAdditions.h
//  Velocity
//
//  Created by Matthew Bischoff on 8/3/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (LCKAdditions)

/// Denotes that the response specified a status code between 200 and 299 inclusive.
@property (readonly, getter=isSuccessful) BOOL successful;

@end
