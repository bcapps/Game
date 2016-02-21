//
//  UIFont+LCKAdditions.h
//  Velocity
//
//  Created by Matthew Bischoff on 7/25/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LCKAdditions)

/// Returns a human readable display name of a font, or the font's family name if none is defined.
@property (nonatomic, readonly) NSString *displayFamilyName;

/// Returns a UIFont object that represents the default UITableViewCell textLabel style, but adjusted for dynamic type.
+ (UIFont *)preferredCellTextLabelFont;

+ (UIFont *)preferredCellTextLabelTitleFont;
+ (UIFont *)preferredCellTextLabelSubtitleFont;

@end
