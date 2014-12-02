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

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context {
    Bandit *bandit = [[self alloc] initWithContext:context];
    
    bandit.vitality = @(12);
    bandit.strength = @(14);
    bandit.dexterity = @(9);
    bandit.intelligence = @(8);
    bandit.faith = @(10);
    
    return bandit;
}

@end
