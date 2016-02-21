//
//  UIFont+LCKAdditions.m
//  Velocity
//
//  Created by Matthew Bischoff on 7/25/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UIFont+LCKAdditions.h"

@implementation UIFont (LCKAdditions)

- (NSString *)displayFamilyName {
    if ([self isSystemFontFamily]) {
        return NSLocalizedString(@"Helvetica Neue", @"The moniker assigned to the default system font");
    }

    return self.familyName;
}

- (BOOL)isSystemFontFamily {
    NSString *systemFontFamilyName = [UIFont systemFontOfSize:[UIFont systemFontSize]].familyName;
    if ([self.familyName isEqualToString:systemFontFamilyName]) {
        return YES;
    }
    return NO;
}

+ (UIFont *)preferredCellTextLabelFont {
    UIFont *dynamicHeadlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    return [[UIFont systemFontOfSize:[UIFont labelFontSize]] fontWithSize:dynamicHeadlineFont.pointSize];
}

+ (UIFont *)preferredCellTextLabelTitleFont {
    CGFloat defaultTitleFontSize = 18.0;
    CGFloat defaultPreferredFontSize = 17.0;

    UIFont *dynamicHeadlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    return [[UIFont systemFontOfSize:[UIFont labelFontSize]] fontWithSize:(dynamicHeadlineFont.pointSize * defaultTitleFontSize/defaultPreferredFontSize)];
}

+ (UIFont *)preferredCellTextLabelSubtitleFont {
    UIFont *dynamicHeadlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    return [[UIFont systemFontOfSize:[UIFont labelFontSize]] fontWithSize:dynamicHeadlineFont.pointSize];
}

@end
