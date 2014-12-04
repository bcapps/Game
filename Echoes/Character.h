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
@property (nonatomic, retain) id equippedItems;
@property (nonatomic, retain) CharacterStats *characterStats;

@property (nonatomic, readonly) NSNumber * maximumHealth;
@property (nonatomic, readonly) CharacterGender characterGender;

@end
