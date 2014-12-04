//
//  LCKItem.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItem.h"

NSString * const LCKItemNameKey = @"name";
NSString * const LCKItemActionKey = @"actionText";
NSString * const LCKItemDescriptionKey = @"descriptiveText";
NSString * const LCKItemFlavorKey = @"flavorText";
NSString * const LCKItemImageKey = @"imageName";
NSString * const LCKItemAttributeRequirementsKey = @"attributeRequirements";
NSString * const LCKItemItemSlotsKey = @"itemSlots";

NSString * const LCKItemLeftHandKey = @"lefthand";
NSString * const LCKItemRightHandKey = @"righthand";
NSString * const LCKItemTwoHandKey = @"twohand";
NSString * const LCKItemHelmetKey = @"helmet";
NSString * const LCKItemChestKey = @"chest";
NSString * const LCKItemBootsKey = @"boots";
NSString * const LCKItemFirstAccessory = @"firstaccessory";
NSString * const LCKItemSecondAccessory = @"secondAccessory";

@implementation LCKItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary objectForKey:LCKItemNameKey];
        _actionText = [dictionary objectForKey:LCKItemActionKey];
        _descriptionText = [dictionary objectForKey:LCKItemDescriptionKey];
        _flavorText = [dictionary objectForKey:LCKItemFlavorKey];
        _imageName = [dictionary objectForKey:LCKItemImageKey];
        _attributeRequirements = [dictionary objectForKey:LCKItemAttributeRequirementsKey];
        
        NSMutableArray *appropriateSlots = [NSMutableArray array];
        for (NSString *slotString in [dictionary objectForKey:LCKItemItemSlotsKey]) {
            NSNumber *slotNumber = @([self itemSlotForSlotString:slotString]);
            
            [appropriateSlots addObject:slotNumber];
        }
        
        _itemSlots = appropriateSlots;
    }
    
    return self;
}

- (LCKItemSlot)itemSlotForSlotString:(NSString *)slotString {
    if ([slotString isEqualToString:LCKItemLeftHandKey]) {
        return LCKItemSlotLeftHand;
    }
    else if ([slotString isEqualToString:LCKItemRightHandKey]) {
        return LCKItemSlotRightHand;
    }
    else if ([slotString isEqualToString:LCKItemHelmetKey]) {
        return LCKItemSlotHelmet;
    }
    else if ([slotString isEqualToString:LCKItemChestKey]) {
        return LCKItemSlotChest;
    }
    else if ([slotString isEqualToString:LCKItemBootsKey]) {
        return LCKItemSlotBoots;
    }
    else if ([slotString isEqualToString:LCKItemFirstAccessory]) {
        return LCKItemSlotFirstAccessory;
    }
    else if ([slotString isEqualToString:LCKItemSecondAccessory]) {
        return LCKItemSlotSecondAccessory;
    }
    else if ([slotString isEqualToString:LCKItemTwoHandKey]) {
        return LCKItemSlotTwoHand;
    }
    
    return 0;
}

- (BOOL)isAppropriateForItemSlot:(LCKItemSlot)itemSlot {
    return [self.itemSlots containsObject:@(itemSlot)];
}

@end
