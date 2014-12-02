//
//  Hunter.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Hunter.h"

@implementation Hunter

- (UIImage *)classImage {
    return [UIImage imageNamed:@"HunterIcon"];
}

- (NSString *)className {
    return @"Hunter";
}

- (NSString *)classDescription {
    return @"Specializes in bows, due to their high initial dexterity stat. Favors high dexterity weapons such as Spears and Rapiers";
}

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context {
    Hunter *hunter = [[self alloc] initWithContext:context];
    
    hunter.vitality = @(11);
    hunter.strength = @(12);
    hunter.dexterity = @(14);
    hunter.intelligence = @(9);
    hunter.faith = @(9);
    
    return hunter;
}

@end
