//
//  LCKMonsterAttribute.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterAttribute.h"

NSString * const LCKMonsterAttributeName = @"name";
NSString * const LCKMonsterAttributeDescription = @"description";

@implementation LCKMonsterAttribute

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary objectForKey:LCKMonsterAttributeName];
        _attributeDescription = [dictionary objectForKey:LCKMonsterAttributeDescription];
    }
    
    return self;
}

@end
