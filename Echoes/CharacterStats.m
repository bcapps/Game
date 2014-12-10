//
//  CharacterStats.m
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

@synthesize classImage;
@synthesize classDescription;
@synthesize className;
@synthesize startingHealthModification;

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    return nil;
}

- (NSNumber *)statHealth {
    NSUInteger health = CharacterStatsInitialHealth + self.startingHealthModification + (CharacterStatsVitalityModifier * self.vitality.integerValue);
    
    return @(health);
}

- (NSString *)statAsStringForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return [NSString stringWithFormat:@"%@", self.vitality];
        case LCKStatTypeStrength:
            return [NSString stringWithFormat:@"%@", self.strength];
        case LCKStatTypeDexterity:
            return [NSString stringWithFormat:@"%@", self.dexterity];
        case LCKStatTypeIntelligence:
            return [NSString stringWithFormat:@"%@", self.intelligence];
        case LCKStatTypeFaith:
            return [NSString stringWithFormat:@"%@", self.faith];
    }
}

+ (NSString *)statNameForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return @"VIT";
        case LCKStatTypeStrength:
            return @"STR";
        case LCKStatTypeDexterity:
            return @"DEX";
        case LCKStatTypeIntelligence:
            return @"INT";
        case LCKStatTypeFaith:
            return @"FAI";
    }
}

- (NSNumber *)statValueForStatString:(NSString *)statString {
    if ([statString isEqualToString:[[self class] statNameForStatType:LCKStatTypeVitality]]) {
        return self.vitality;
    }
    else if ([statString isEqualToString:[[self class] statNameForStatType:LCKStatTypeStrength]]) {
        return self.strength;
    }
    else if ([statString isEqualToString:[[self class] statNameForStatType:LCKStatTypeDexterity]]) {
        return self.dexterity;
    }
    else if ([statString isEqualToString:[[self class] statNameForStatType:LCKStatTypeIntelligence]]) {
        return self.intelligence;
    }
    else if ([statString isEqualToString:[[self class] statNameForStatType:LCKStatTypeFaith]]) {
        return self.faith;
    }
    
    return nil;
}

@end
