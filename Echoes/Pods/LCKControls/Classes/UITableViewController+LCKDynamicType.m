//
//  LCKDynamicType+UITableViewController.m
//  Velocity
//
//  Created by Matthew Bischoff on 8/11/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UITableViewController+LCKDynamicType.h"
#import <LCKCategories/UIFont+LCKAdditions.h>

NSString * const LCKTableViewControllerFontSizingCharacter = @".";

CGFloat const LCKTableViewControllerMinimumCellHeight = 44;

static CGFloat const LCKTableViewControllerBaselineFontPointSize = 17;
static CGFloat const LCKTableViewControllerBaselineCellVerticalMargins = 24;

@implementation UITableViewController (LCKDynamicType)

- (CGFloat)dynamicTypeTableViewRowHeight {
    return [[self class] dynamicTypeTableViewRowHeight];
}

+ (CGFloat)dynamicTypeTableViewRowHeight {
    UIFont *preferredFont = [UIFont preferredCellTextLabelFont];
    
    CGSize textSize = [LCKTableViewControllerFontSizingCharacter sizeWithAttributes:@{NSFontAttributeName : preferredFont}];
    CGFloat marginRatio = LCKTableViewControllerBaselineCellVerticalMargins / LCKTableViewControllerBaselineFontPointSize;
    CGFloat verticalMargins = preferredFont.pointSize * marginRatio;
    
    CGFloat height = roundf(textSize.height + verticalMargins);
    
    return MAX(LCKTableViewControllerMinimumCellHeight, height);
}

@end
