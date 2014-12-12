//
//  LCKStatusButton.m
//  Echoes
//
//  Created by Andrew Harrison on 12/12/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKStatusButton.h"
#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

@implementation LCKStatusButton

#pragma mark - NSObject+UINibLoading

- (void)awakeFromNib {
    [self commonInitialization];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 2, 14.0 , 14.0);
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.imageView.frame) + 5.0, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame) - 5.0, CGRectGetHeight(self.frame));
    
    [self.titleLabel sizeToFit];
}

#pragma mark - LCKStatusButton

- (void)commonInitialization {
    self.titleLabel.font = [UIFont descriptiveTextFontOfSize:13.0];
    [self setTitleColor:[UIColor descriptiveTextColor] forState:UIControlStateNormal];
}

@end
