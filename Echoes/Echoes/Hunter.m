//
//  Hunter.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Hunter.h"

@implementation Hunter

- (NSString *)className {
    return @"Hunter";
}

- (NSString *)classDescription {
    return @"Specializes in bows, due to their high initial dexterity stat. Favors high dexterity weapons such as Spears and Rapiers";
}

- (NSUInteger)startingHealthModification {
    return 1;
}

+ (instancetype)newCharacterStatsInContext:(NSManagedObjectContext *)context {
    Hunter *hunter = [[self alloc] initWithContext:context];
    
    hunter.vitality = @(1);
    hunter.strength = @(2);
    hunter.dexterity = @(3);
    hunter.intelligence = @(-1);
    hunter.faith = @(-1);

    return hunter;
}

@end
