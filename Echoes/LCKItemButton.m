//
//  LCKItemButton.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItemButton.h"

@implementation LCKItemButton

#pragma mark - NSCoding

- (void)awakeFromNib {
    [self commonInitialization];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

#pragma mark - LCKItemButton

- (void)commonInitialization {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8.0;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

@end
