//
//  UITableViewHeaderFooterView+LCKAdditions.m
//  Pods
//
//  Created by Andrew Harrison on 4/19/14.
//
//

#import "UITableViewHeaderFooterView+LCKAdditions.h"

@implementation UITableViewHeaderFooterView (LCKAdditions)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

@end
