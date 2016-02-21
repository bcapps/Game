//
//  LCKCharacterPortrait.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKCharacterPortrait.h"

@interface LCKCharacterPortrait ()

@property (nonatomic) UIImageView *portraitImageView;

@end

@implementation LCKCharacterPortrait

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.masksToBounds = NO;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
        
        _portraitImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _portraitImageView.contentMode = UIViewContentModeScaleToFill;
        _portraitImageView.backgroundColor = [UIColor clearColor];
        _portraitImageView.center = self.center;
        
        [self addSubview:_portraitImageView];
    }
    
    return self;
}

- (void)setPortraitImage:(UIImage *)portraitImage {
    self.portraitImageView.image = portraitImage;
}

@end
