//
//  LCKEmptyView.h
//  Velocity
//
//  Created by Matthew Bischoff on 9/8/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCKAccessibilityContainerView;

@interface LCKEmptyView : UIView

@property (nonatomic, readonly) LCKAccessibilityContainerView *containerView;

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;

@end
