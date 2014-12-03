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

- (NSUInteger)startingHealthModification {
    return -1;
}

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    Bandit *bandit = [[self alloc] initWithContext:context];
    
    bandit.vitality = @(1);
    bandit.strength = @(2);
    bandit.dexterity = @(2);
    bandit.intelligence = @(-1);
    bandit.faith = @(0);

    return bandit;
}

@end
