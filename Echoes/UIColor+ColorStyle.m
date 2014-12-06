//
//  UIColor+ColorStyle.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "UIColor+ColorStyle.h"

@implementation UIColor (ColorStyle)

+ (UIColor *)flavorTextColor {
    return [UIColor colorWithWhite:0.4 alpha:1.0];
}

+ (UIColor *)descriptiveTextColor {
    return [UIColor lightTextColor];
}

+ (UIColor *)titleTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)backgroundColor {
    return [UIColor blackColor];
}

+ (UIColor *)removeColor {
    return [UIColor colorWithRed:0.85 green:0.05 blue:0.0 alpha:1.0];
}

@end
