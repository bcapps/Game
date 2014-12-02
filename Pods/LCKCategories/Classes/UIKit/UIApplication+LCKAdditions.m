//
//  UIApplication+LCKAdditions.m
//  Pods
//
//  Created by Twig on 3/1/14.
//
//

#import "UIApplication+LCKAdditions.h"

@implementation UIApplication (LCKAdditions)

- (CGFloat)statusBarHeight {
    CGRect statusBarFrame = [self.keyWindow convertRect:self.statusBarFrame fromView:nil];
    
    return MIN(CGRectGetHeight(statusBarFrame), CGRectGetWidth(statusBarFrame));
}

@end
