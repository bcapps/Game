//
//  LCKItem.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_OPTIONS(NSUInteger, LCKItemSlot) {
    LCKItemSlotHelmet,
    LCKItemSlotChest,
    LCKItemSlotBoots,
    LCKItemSlotAccessory,
    LCKItemSlotOneHand,
    LCKItemSlotTwoHand
};

extern NSString * const LCKItemTypeNameOneHanded;
extern NSString * const LCKItemTypeNameTwoHanded ;
extern NSString * const LCKItemTypeNameAccessory;
extern NSString * const LCKItemTypeNameHelmet;
extern NSString * const LCKItemTypeNameChest;
extern NSString * const LCKItemTypeNameBoots;

@interface LCKItem : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *actionText;
@property (nonatomic, readonly) NSString *descriptionText;
@property (nonatomic, readonly) NSString *flavorText;
@property (nonatomic, readonly) NSString *imageName;
@property (nonatomic, readonly) NSArray *attributeRequirements;
@property (nonatomic, readonly) LCKItemSlot itemSlot;

@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, getter=isEquipped) BOOL equipped;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isAppropriateForItemSlot:(LCKItemSlot)itemSlot;

+ (NSString *)typeDisplayNameForItemSlot:(LCKItemSlot)itemSlot;

@end
