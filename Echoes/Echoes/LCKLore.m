//
//  LCKLore.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLore.h"

NSString * const LCKLoreTitleKey = @"title";
NSString * const LCKLoreDescriptionKey = @"lore";

@implementation LCKLore

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _title = [dictionary objectForKey:LCKLoreTitleKey];
        _lore = [dictionary objectForKey:LCKLoreDescriptionKey];
    }
    
    return self;
}

@end
