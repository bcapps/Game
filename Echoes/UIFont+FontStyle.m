//
//  UIFont+FontStyle.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "UIFont+FontStyle.h"

@implementation UIFont (FontStyle)

+ (UIFont *)descriptiveTextFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Medium" size:size];
}

+ (UIFont *)italicDescriptiveTextFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-MediumOblique" size:size];
}

+ (UIFont *)titleTextFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Heavy" size:size];
}

+ (UIFont *)boldTitleTextFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Black" size:size];
}

@end
