//
//  UIView+LCKAdditions.h
//  Velocity
//
//  Created by Matthew Bischoff on 9/3/12.
//  Copyright (c) 2012 Lickability. All rights reserved.
//



@interface UIView (LCKAdditions)

+ (UIViewAnimationOptions)animationOptionsWithCurve:(UIViewAnimationCurve)curve;
- (CGRect)statusBarFrame;
- (void)animateChangesWithDuration:(NSTimeInterval)duration;

@end
