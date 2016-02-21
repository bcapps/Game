//
//  LCKStatCell.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKStatCell.h"
#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

NSString * const LCKStatCellReuseIdentifier = @"LCKStatCellReuseIdentifier";

@interface LCKStatCell ()

@property (nonatomic) UILabel *statNameLabel;
@property (nonatomic) UILabel *statValueLabel;

@end

@implementation LCKStatCell

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.statNameLabel];
        [self addSubview:self.statValueLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.statNameLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    self.statValueLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.alpha = 0.5;
    }
    else {
        self.alpha = 1.0;
    }
}

#pragma mark - LCKStatCell

- (UILabel *)statNameLabel {
    if (!_statNameLabel) {
        _statNameLabel = [[UILabel alloc] init];
        _statNameLabel.textColor = [UIColor titleTextColor];
        _statNameLabel.textAlignment = NSTextAlignmentCenter;
        _statNameLabel.font = [UIFont titleTextFontOfSize:14.0];
    }
    
    return _statNameLabel;
}

- (UILabel *)statValueLabel {
    if (!_statValueLabel) {
        _statValueLabel = [[UILabel alloc] init];
        _statValueLabel.textAlignment = NSTextAlignmentCenter;
        _statValueLabel.textColor = [UIColor descriptiveTextColor];
        _statValueLabel.font = [UIFont descriptiveTextFontOfSize:14.0];
    }
    
    return _statValueLabel;
}

@end
