//
//  LCKLore.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLore.h"

@implementation LCKLore

- (instancetype)initWithTitle:(NSString *)title lore:(NSString *)lore {
    self = [super init];
    
    if (self) {
        _title = title;
        _lore = lore;
    }
    
    return self;
}

@end
