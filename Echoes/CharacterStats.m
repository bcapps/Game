//
//  CharacterClass.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "CharacterStats.h"

NSUInteger const CharacterStatsInitialHealth = 10;
NSUInteger const CharacterStatsVitalityModifier = 3;

@implementation CharacterStats

@dynamic strength;
@dynamic intelligence;
@dynamic faith;
@dynamic vitality;
@dynamic dexterity;
@dynamic maximumHealth;
@dynamic currentHealth;

@synthesize classImage;
@synthesize classDescription;
@synthesize className;

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    return nil;
}

@end
