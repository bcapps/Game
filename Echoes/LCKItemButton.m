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
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

#pragma mark - LCKItemButton

- (void)setItem:(LCKItem *)item {
    _item = item;
    
    if (item) {
        [self setImage:item.image forState:UIControlStateNormal];
        self.imageView.tintColor = self.tintColor;
    }
    else {
        [self setImage:[LCKItemButton placeholderItemImageForItemSlot:self.itemSlot] forState:UIControlStateNormal];
        self.imageView.tintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
}

+ (UIImage *)placeholderItemImageForItemSlot:(LCKItemSlot)itemSlot {
    UIImage *placeholderImage;
    
    switch (itemSlot) {
        case LCKItemSlotOneHand:
            placeholderImage = [UIImage imageNamed:@"oneHandIcon"];
            break;
        case LCKItemSlotTwoHand:
            placeholderImage = [UIImage imageNamed:@"twoHandIcon"];
            break;
        case LCKItemSlotHelmet:
            placeholderImage = [UIImage imageNamed:@"helmetIcon"];
            break;
        case LCKItemSlotChest:
            placeholderImage = [UIImage imageNamed:@"chestIcon"];
            break;
        case LCKItemSlotBoots:
            placeholderImage = [UIImage imageNamed:@"bootsIcon"];
            break;
        case LCKItemSlotAccessory:
            placeholderImage = [UIImage imageNamed:@"accessoryIcon"];
            break;
        case LCKItemSlotSpell:
            placeholderImage = [UIImage imageNamed:@"spellIcon"];
            break;
    }
    
    return [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)commonInitialization {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8.0;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
}

@end
