//
//  Sorcerer.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "Sorcerer.h"

@implementation Sorcerer

- (UIImage *)classImage {
    return [UIImage imageNamed:@"SorcererIcon"];
}

- (NSString *)className {
    return @"Sorcerer";
}

- (NSString *)classDescription {
    return @"Uses magic as his primary offensive tool. Limited to small weapons due to low starting strength.";
}

@end
