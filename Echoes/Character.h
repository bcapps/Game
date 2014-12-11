//
//  Character.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CharacterStats;
@class LCKItem;

typedef NS_ENUM(NSUInteger, CharacterGender) {
    CharacterGenderMale,
    CharacterGenderFemale
};

@interface Character : NSManagedObject

@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * currentHealth;
@property (nonatomic, retain) id items;
@property (nonatomic, retain) CharacterStats *characterStats;

@property (nonatomic, readonly) NSNumber * maximumHealth;
@property (nonatomic, readonly) CharacterGender characterGender;

@property (nonatomic, readonly) NSArray *equippedWeapons;
@property (nonatomic, readonly) NSArray *equippedAccessories;
@property (nonatomic, readonly) NSArray *equippedSpells;
@property (nonatomic, readonly) LCKItem *equippedHelm;
@property (nonatomic, readonly) LCKItem *equippedChest;
@property (nonatomic, readonly) LCKItem *equippedBoots;

- (void)equipItem:(LCKItem *)item;
- (void)unequipItem:(LCKItem *)item;

- (void)addItemToInventory:(LCKItem *)item;
- (void)removeItemFromInventory:(LCKItem *)item;

- (BOOL)meetsRequirement:(NSString *)requirement forItem:(LCKItem *)item;
- (BOOL)meetsRequirementsForItem:(LCKItem *)item;

@end
