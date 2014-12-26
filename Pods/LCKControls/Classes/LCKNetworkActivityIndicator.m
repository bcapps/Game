//
//  LCKNetworkActivityIndicator.m
//  Velocity
//
//  Created by Andrew Harrison on 9/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKNetworkActivityIndicator.h"

@implementation LCKNetworkActivityIndicator

static NSInteger counter;

+ (void)show {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        counter++;
        if (counter == 1) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }];
}

+ (void)hide {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (counter > 0) {
            counter--;
            if (counter == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
    }];
}

+ (void)hideAll {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        counter = 0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end


