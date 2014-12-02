//
//  UITableViewCell+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "UITableViewCell+LCKAdditions.h"
#import "NSProcessInfo+LCKAdditions.h"

@implementation UITableViewCell (LCKAdditions)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (UIButton *)accessoryButton {
    NSArray *viewsToSearch;
    
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:[NSProcessInfo iOS8OperatingSystemVersion]]) {
        viewsToSearch = self.subviews;
    }
    else {
       viewsToSearch = [[self.subviews firstObject] subviews];
    }
    
    for (UIView *view in viewsToSearch) {
        if ([view isKindOfClass:[UIButton class]]) {
            return (UIButton *)view;
        }
    }
    
    return nil;
}

@end
