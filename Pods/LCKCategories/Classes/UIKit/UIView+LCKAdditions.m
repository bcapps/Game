//
//  UIView+LCKAddtions.h
//  Velocity
//
//  Created by Matthew Bischoff on 9/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//

#import "UIView+LCKAdditions.h"

@implementation UIView (LCKAdditions)

+ (UIViewAnimationOptions)animationOptionsWithCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
        default:
            return UIViewAnimationOptionCurveLinear;
    }
}

- (CGRect)statusBarFrame {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.window convertRect:statusBarFrame fromWindow: nil];
    
    CGRect statusBarViewRect = [self convertRect:statusBarWindowRect fromView: nil];
    return statusBarViewRect;
}

- (void)animateChangesWithDuration:(NSTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.layer addAnimation:transition forKey:nil];
}

@end
