//
//  LCKMath.m
//  Pods
//
//  Created by Matthew Bischoff on 4/30/14.
//
//

#import "LCKMath.h"

CGFloat LCKCeilPointsToNearestAmount(CGFloat number, CGFloat amount) {
    CGFloat result = number / amount;
    result = ceil(result);
    result = result * amount;
    
    return result;
}

CGFloat LCKCeilPointsToNearestPixel(CGFloat points) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return LCKCeilPointsToNearestAmount(points, 1/scale);
}
