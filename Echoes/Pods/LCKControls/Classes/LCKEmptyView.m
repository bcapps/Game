//
//  LCKEmptyView.m
//  Velocity
//
//  Created by Matthew Bischoff on 9/8/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKEmptyView.h"
#import "LCKAccessibilityContainerView.h"

@interface LCKEmptyView ()

@property (nonatomic) LCKAccessibilityContainerView *containerView;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailTextLabel;

@end

@implementation LCKEmptyView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    [self setupContainerView];
    [self setupTitleLabel];
    [self setupDetailTextLabel];
    
    [_containerView.accessibilityViews addObject:_titleLabel];
    [_containerView.accessibilityViews addObject:_detailTextLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = 40.0;
    
    CGFloat interLabelMargin = 0.0;
    
    CGRect insetRect = CGRectInset(self.bounds, horizontalMargin, 0);
    
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:insetRect.size];
    CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:insetRect.size];
    
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - horizontalMargin * 2.0, titleLabelSize.height + detailTextLabelSize.height + interLabelMargin);
    self.containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), titleLabelSize.height);
    self.detailTextLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + interLabelMargin, CGRectGetWidth(self.containerView.bounds), detailTextLabelSize.height);
}

#pragma mark - LCKEmptyView

- (void)setupContainerView {
    _containerView = [[LCKAccessibilityContainerView alloc] init];
    [self addSubview:_containerView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 3;
    _titleLabel.font = [UIFont systemFontOfSize:28.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _titleLabel.contentMode = UIViewContentModeCenter;

    [_containerView addSubview:_titleLabel];
}

- (void)setupDetailTextLabel {
    _detailTextLabel = [[UILabel alloc] init];
    _detailTextLabel.numberOfLines = 0;
    _detailTextLabel.font = [UIFont systemFontOfSize:15.0]; // was UIFontTextStyleSubheadline, however since the headline wasn't dynamic, this looked odd.
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    _detailTextLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    _detailTextLabel.contentMode = UIViewContentModeCenter;

    [_containerView addSubview:_detailTextLabel];
}


@end
