//
//  Thief.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Thief.h"

@implementation Thief

- (NSString *)className {
    return @"Thief";
}

- (NSString *)classDescription {
    return @"High critical hit rate and very fast. They aren’t built very solidly, however, with low vitality, strength and endurance.";
}

- (NSUInteger)startingHealthModification {
    return 1;
}

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    Thief *thief = [[self alloc] initWithContext:context];
    
    thief.vitality = @(0);
    thief.strength = @(0);
    thief.dexterity = @(3);
    thief.intelligence = @(1);
    thief.faith = @(1);
    
    return thief;
}

@end
