//
//  UIScreen+LCKAdditions.m
//  Pods
//
//  Created by Matthew Bischoff on 4/30/14.
//
//

#import "UIScreen+LCKAdditions.h"

@implementation UIScreen (LCKAdditions)

- (BOOL)isRetina {
    return self.scale == 2.0;
}

@end
