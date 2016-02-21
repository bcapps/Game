//
//  LCKNetworkActivityIndicator.h
//  Velocity
//
//  Created by Andrew Harrison on 9/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Thread-safe wrapper for `networkActivityIndicatorVisible` that balances show/hide calls. */
@interface LCKNetworkActivityIndicator : NSObject

+ (void)show;
+ (void)hide;
+ (void)hideAll;

@end
