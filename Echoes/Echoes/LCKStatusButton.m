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
    
    self.imageView.frame = CGRectMake(0, 0.0, 32.0 , CGRectGetHeight(self.frame));
    
    CGRect soulLabelFrame = CGRectMake(CGRectGetWidth(self.imageView.frame) + 5.0, 2.0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame) - 2.0, CGRectGetHeight(self.frame) - 2.0);
    
    self.soulLabel.frame = soulLabelFrame;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.soulLabel.alpha = 0.5;
    }
    else {
        self.soulLabel.alpha = 1.0;
    }
}

#pragma mark - LCKStatusButton

- (void)commonInitialization {
    self.soulLabel = [[UICountingLabel alloc] init];
    
    self.soulLabel.font = [UIFont descriptiveTextFontOfSize:15.0];
    self.soulLabel.textColor = [UIColor descriptiveTextColor];
    
    [self addSubview:self.soulLabel];
}

@end
