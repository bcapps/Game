//
//  Cleric.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Cleric.h"

@implementation Cleric

- (UIImage *)classImage {
    return [UIImage imageNamed:@"ClericIcon"];
}

- (NSString *)className {
    return @"Cleric";
}

- (NSString *)classDescription {
    return @"Can use Miracles to heal thanks to their high starting Faith stat. Low starting dexterity limits weapon choice.";
}

@end
