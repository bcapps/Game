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

@synthesize classDescription;
@synthesize className;
@synthesize startingHealthModification;

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    return nil;
}

- (void)addStatValue:(NSUInteger)statValue forStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            self.vitality = @(self.vitality.integerValue + 1);
            break;
        case LCKStatTypeStrength:
            self.strength = @(self.strength.integerValue + 1);
            break;
        case LCKStatTypeDexterity:
            self.dexterity = @(self.dexterity.integerValue + 1);
            break;
        case LCKStatTypeIntelligence:
            self.intelligence = @(self.intelligence.integerValue + 1);
            break;
        case LCKStatTypeFaith:
            self.faith = @(self.faith.integerValue + 1);
            break;
    }
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
    
    return @"";
}

- (NSNumber *)statValueForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return self.vitality;
        case LCKStatTypeStrength:
            return self.strength;
        case LCKStatTypeDexterity:
            return self.dexterity;
        case LCKStatTypeIntelligence:
            return self.intelligence;
        case LCKStatTypeFaith:
            return self.faith;
    }
    
    return @(0);
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
    
    return @"";
}

+ (NSString *)statTitleForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return @"Vitality";
        case LCKStatTypeStrength:
            return @"Strength";
        case LCKStatTypeDexterity:
            return @"Dexterity";
        case LCKStatTypeIntelligence:
            return @"Intelligence";
        case LCKStatTypeFaith:
            return @"Faith";
    }
    
    return @"";
}

+ (NSString *)statDescriptionForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return @"· Increases health by 3 per point.\n· Increases resistance to bleeding effects.\n· Increases resistance to petrification.\n· Reduces damage taken by dark attacks.";
        case LCKStatTypeStrength:
            return @"· Increases damage and attack rolls made with strength based weapons.\n· Increases resistance to toxic effects.\n· Reduces your chance to be staggered when hit.";
        case LCKStatTypeDexterity:
            return @"· Increases damage and attack rolls made with dexterity based weapons.\n· Lowers your chance of being hit by physical attacks.";
        case LCKStatTypeIntelligence:
            return @"· Increases damage done by spells.\n· Increases chance to hit with spells.\n· Increases resistance to poison.";
        case LCKStatTypeFaith:
            return @"· Increases damage and healing done by miracles.\n· Lowers your chance of being hit by magical attacks.\n· Increases resistance to curses.";
    }
    
    return @"";
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

- (UIImage *)classImageForGender:(CharacterGender)gender {
    NSString *imageName = [NSString stringWithFormat:@"%@Icon", self.className];
    
    if (gender == CharacterGenderFemale) {
        imageName = [imageName stringByAppendingString:@"Female"];
    }
    
    return [UIImage imageNamed:imageName];
}

@end
