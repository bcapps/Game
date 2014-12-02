//
//  Thief.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Thief.h"

@implementation Thief

- (UIImage *)classImage {
    return [UIImage imageNamed:@"ThiefIcon"];
}

- (NSString *)className {
    return @"Thief";
}

- (NSString *)classDescription {
    return @"High critical hit rate and very fast. They aren’t built very solidly, however, with low vitality, strength and endurance.";
}

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context {
    Thief *thief = [[self alloc] initWithContext:context];
    
    thief.vitality = @(9);
    thief.strength = @(9);
    thief.dexterity = @(15);
    thief.intelligence = @(12);
    thief.faith = @(11);
    
    return thief;
}

@end
