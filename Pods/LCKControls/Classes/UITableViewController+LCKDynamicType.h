//
//  LCKDynamicType+UITableViewController.h
//  Velocity
//
//  Created by Matthew Bischoff on 8/11/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

extern NSString * const LCKTableViewControllerFontSizingCharacter;
extern CGFloat const LCKTableViewControllerMinimumCellHeight;

@interface UITableViewController (LCKDynamicType)

- (CGFloat)dynamicTypeTableViewRowHeight;
+ (CGFloat)dynamicTypeTableViewRowHeight;

@end
