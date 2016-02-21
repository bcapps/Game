//
//  LCKScalingImageView.m
//  NYTiPhoneReader
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import "LCKScalingImageView.h"

@implementation LCKScalingImageView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithImage:nil frame:frame];
}

- (id)initWithImage:(UIImage *)image frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupInternalImageView:image];
        [self setupImageScrollView];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupInternalImageView:(UIImage *)image {
    self.internalImageView = [[UIImageView alloc] initWithImage:image];
    self.internalImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [self addSubview:self.internalImageView];
    
    self.contentSize = image.size;
}

- (void)setupImageScrollView {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
}

#pragma mark - Centering

- (void)centerScrollViewContents {
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.internalImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.internalImageView.frame = contentsFrame;
}

@end
