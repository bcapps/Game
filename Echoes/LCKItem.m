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
NSString * const LCKItemItemSlotKey = @"itemSlot";
NSString * const LCKItemHasUseActionKey = @"hasUseAction";
NSString * const LCKItemEmptyVersionKey = @"emptyVersion";

NSString * const LCKItemOneHandKey = @"onehand";
NSString * const LCKItemTwoHandKey = @"twohand";
NSString * const LCKItemHelmetKey = @"helmet";
NSString * const LCKItemChestKey = @"chest";
NSString * const LCKItemBootsKey = @"boots";
NSString * const LCKItemAccessoryKey = @"accessory";
NSString * const LCKItemSpellKey = @"spell";

NSString * const LCKItemTypeNameOneHanded = @"One-Handed";
NSString * const LCKItemTypeNameTwoHanded = @"Two-Handed";
NSString * const LCKItemTypeNameAccessory = @"Accessory";
NSString * const LCKItemTypeNameHelmet = @"Helmet";
NSString * const LCKItemTypeNameChest = @"Chest";
NSString * const LCKItemTypeNameBoots = @"Boots";
NSString * const LCKItemTypeNameSpell = @"Spell";

NSString * const LCKItemCodingNameKey = @"LCKItemCodingNameKey";
NSString * const LCKItemCodingActionKey = @"LCKItemCodingActionKey";
NSString * const LCKItemCodingDescriptionKey = @"LCKItemCodingDescriptionKey";
NSString * const LCKItemCodingFlavorKey = @"LCKItemCodingFlavorKey";
NSString * const LCKItemCodingImageKey = @"LCKItemCodingImageKey";
NSString * const LCKItemCodingAttributeKey = @"LCKItemCodingAttributeKey";
NSString * const LCKItemCodingItemSlotKey = @"LCKItemCodingItemSlotKey";
NSString * const LCKItemCodingEquipmentSlotKey = @"LCKItemCodingEquipmentSlotKey";
NSString * const LCKItemCodingEquippedKey = @"LCKItemCodingEquippedKey";
NSString * const LCKItemCodingHasUseActionKey = @"LCKItemCodingHasUseActionKey";
NSString * const LCKItemCodingEmptyVersionKey = @"LCKItemCodingEmptyVersionKey";

@interface LCKItem ()

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *actionText;
@property (nonatomic) NSString *descriptionText;
@property (nonatomic) NSString *flavorText;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSArray *attributeRequirements;

@property (nonatomic) NSNumber *itemSlotNumber;
@property (nonatomic) NSNumber *equipmentSlotNumber;

@property (nonatomic) BOOL hasUseAction;
@property (nonatomic) NSString *emptyItemName;

@end

@implementation LCKItem

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingNameKey];
        _actionText = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingActionKey];
        _descriptionText = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingDescriptionKey];
        _flavorText = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingFlavorKey];
        _imageName = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingImageKey];
        _attributeRequirements = [aDecoder decodeObjectOfClass:[NSArray class] forKey:LCKItemCodingAttributeKey];
        _itemSlotNumber = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:LCKItemCodingItemSlotKey];
        _equipmentSlotNumber = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:LCKItemCodingEquipmentSlotKey];
        _equipped = [aDecoder decodeBoolForKey:LCKItemCodingEquippedKey];
        _hasUseAction = [aDecoder decodeBoolForKey:LCKItemCodingHasUseActionKey];
        _emptyItemName = [aDecoder decodeObjectOfClass:[NSString class] forKey:LCKItemCodingEmptyVersionKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:LCKItemCodingNameKey];
    [aCoder encodeObject:_actionText forKey:LCKItemCodingActionKey];
    [aCoder encodeObject:_descriptionText forKey:LCKItemCodingDescriptionKey];
    [aCoder encodeObject:_flavorText forKey:LCKItemCodingFlavorKey];
    [aCoder encodeObject:_imageName forKey:LCKItemCodingImageKey];
    [aCoder encodeObject:_attributeRequirements forKey:LCKItemCodingAttributeKey];
    [aCoder encodeObject:_itemSlotNumber forKey:LCKItemCodingItemSlotKey];
    [aCoder encodeObject:_equipmentSlotNumber forKey:LCKItemCodingEquipmentSlotKey];
    [aCoder encodeBool:_equipped forKey:LCKItemCodingEquippedKey];
    [aCoder encodeBool:_hasUseAction forKey:LCKItemCodingHasUseActionKey];
    [aCoder encodeObject:_emptyItemName forKey:LCKItemCodingEmptyVersionKey];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    LCKItem *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        copy.name = [self.name copyWithZone:zone];
        copy.actionText = [self.actionText copyWithZone:zone];
        copy.descriptionText = [self.descriptionText copyWithZone:zone];
        copy.flavorText = [self.flavorText copyWithZone:zone];
        copy.imageName = [self.imageName copyWithZone:zone];
        copy.attributeRequirements = [self.attributeRequirements copyWithZone:zone];
        copy.itemSlotNumber = [self.itemSlotNumber copyWithZone:zone];
        copy.equipmentSlotNumber = [self.equipmentSlotNumber copyWithZone:zone];
        copy.equipped = self.isEquipped;
        copy.hasUseAction = self.hasUseAction;
        copy.emptyItemName = [self.emptyItemName copyWithZone:zone];
    }
    
    return copy;
}

#pragma mark - LCKItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary objectForKey:LCKItemNameKey];
        _actionText = [dictionary objectForKey:LCKItemActionKey];
        _descriptionText = [dictionary objectForKey:LCKItemDescriptionKey];
        _flavorText = [dictionary objectForKey:LCKItemFlavorKey];
        _imageName = [dictionary objectForKey:LCKItemImageKey];
        _attributeRequirements = [dictionary objectForKey:LCKItemAttributeRequirementsKey];
        _equipped = NO;
        _equipmentSlotNumber = @(LCKEquipmentSlotUnequipped);
        _itemSlotNumber = @([self itemSlotForSlotString:[dictionary objectForKey:LCKItemItemSlotKey]]);
        _hasUseAction = [[dictionary objectForKey:LCKItemHasUseActionKey] boolValue];
        _emptyItemName = [dictionary objectForKey:LCKItemEmptyVersionKey];
    }
    
    return self;
}

- (UIImage *)image {
    return [UIImage imageNamed:self.imageName];
}

- (LCKItemSlot)itemSlot {
    return [self.itemSlotNumber integerValue];
}

- (LCKEquipmentSlot)equippedSlot {
    return [self.equipmentSlotNumber integerValue];
}

- (void)setEquippedSlot:(LCKEquipmentSlot)equippedSlot {
    self.equipmentSlotNumber = @(equippedSlot);
}

- (LCKItemSlot)itemSlotForSlotString:(NSString *)slotString {
    if ([slotString isEqualToString:LCKItemOneHandKey]) {
        return LCKItemSlotOneHand;
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
    else if ([slotString isEqualToString:LCKItemAccessoryKey]) {
        return LCKItemSlotAccessory;
    }
    else if ([slotString isEqualToString:LCKItemTwoHandKey]) {
        return LCKItemSlotTwoHand;
    }
    else if ([slotString isEqualToString:LCKItemSpellKey]) {
        return LCKItemSlotSpell;
    }
    
    return 0;
}

- (BOOL)isAppropriateForItemSlot:(LCKItemSlot)itemSlot {
    return self.itemSlot == itemSlot;
}

+ (NSString *)typeDisplayNameForItemSlot:(LCKItemSlot)itemSlot {
    switch (itemSlot) {
        case LCKItemSlotOneHand:
            return LCKItemTypeNameOneHanded;
        case LCKItemSlotTwoHand:
            return LCKItemTypeNameTwoHanded;
        case LCKItemSlotHelmet:
            return LCKItemTypeNameHelmet;
        case LCKItemSlotChest:
            return LCKItemTypeNameChest;
        case LCKItemSlotBoots:
            return LCKItemTypeNameBoots;
        case LCKItemSlotAccessory:
            return LCKItemTypeNameAccessory;
        case LCKItemSlotSpell:
            return LCKItemTypeNameSpell;
    }
}

+ (UIImage *)imageForItemSlot:(LCKItemSlot)itemSlot {
    switch (itemSlot) {
        case LCKItemSlotOneHand:
            return [UIImage imageNamed:@"oneHandIcon"];
        case LCKItemSlotTwoHand:
            return [UIImage imageNamed:@"twoHandIcon"];
        case LCKItemSlotHelmet:
            return [UIImage imageNamed:@"helmetIcon"];
        case LCKItemSlotChest:
            return [UIImage imageNamed:@"chestIcon"];
        case LCKItemSlotBoots:
            return [UIImage imageNamed:@"bootsIcon"];
        case LCKItemSlotAccessory:
            return [UIImage imageNamed:@"accessoryIcon"];
        case LCKItemSlotSpell:
            return [UIImage imageNamed:@"spellIcon"];
    }
}

@end
