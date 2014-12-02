//
//  UICollectionReusableView+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/14/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "UICollectionReusableView+LCKAdditions.h"

@implementation UICollectionReusableView (LCKAdditions)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

@end
