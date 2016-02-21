//
//  UITableViewCell+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

@interface UITableViewCell (LCKAdditions)

+ (NSString *)reuseIdentifier;

/**
 Returns the accessory button from a UITableViewCell.
 */
@property (nonatomic, readonly) UIButton *accessoryButton;

@end
