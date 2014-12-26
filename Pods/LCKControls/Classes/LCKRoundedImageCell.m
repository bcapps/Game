//
//  LCKRoundedImageCell.m
//  Velocity
//
//  Created by Twig on 8/24/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKRoundedImageCell.h"

static const CGFloat LCKRoundedImageCellDefaultMargin = 8.0;

@interface LCKRoundedImageCell ()

@property (nonatomic) UITableViewCellStyle cellStyle;

@end

@implementation LCKRoundedImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.imageView.layer.masksToBounds = YES;
        _cellStyle = style;
        _imageEdgeInsets = UIEdgeInsetsMake(LCKRoundedImageCellDefaultMargin, LCKRoundedImageCellDefaultMargin, LCKRoundedImageCellDefaultMargin, LCKRoundedImageCellDefaultMargin);
        _additionalLeftImagePadding = LCKRoundedImageCellDefaultMargin;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageViewFrame = CGRectMake(self.imageEdgeInsets.left + self.additionalLeftImagePadding, self.imageEdgeInsets.top, CGRectGetWidth(self.imageView.frame) - self.imageEdgeInsets.left - self.imageEdgeInsets.right, CGRectGetHeight(self.imageView.frame) - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom);
    
    self.imageView.layer.cornerRadius = imageViewFrame.size.height / 2.0;
    
    self.imageView.frame = imageViewFrame;
    
    if (self.cellStyle == UITableViewCellStyleSubtitle) {
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + LCKRoundedImageCellDefaultMargin * 2.0;
        self.textLabel.frame = textLabelFrame;
        
        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        detailTextLabelFrame.origin.x = CGRectGetMinX(self.textLabel.frame);
        self.detailTextLabel.frame = detailTextLabelFrame;
    }
}

@end
