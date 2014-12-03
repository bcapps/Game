//
//  Bandit.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Bandit.h"

@implementation Bandit

- (UIImage *)classImage {
    return [UIImage imageNamed:@"BanditIcon"];
}

- (NSString *)className {
    return @"Bandit";
}

- (NSString *)classDescription {
    return @"Specializes in hard-hitting physical attacks, and is great with weapons such as axes and straight swords.";
}

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    Bandit *bandit = [[self alloc] initWithContext:context];
    
    bandit.vitality = @(1);
    bandit.strength = @(2);
    bandit.dexterity = @(2);
    bandit.intelligence = @(-1);
    bandit.faith = @(0);
    bandit.maximumHealth = @(CharacterStatsInitialHealth + (CharacterStatsVitalityModifier * bandit.vitality.integerValue) - 1);
    bandit.currentHealth = bandit.maximumHealth;

    return bandit;
}

@end
