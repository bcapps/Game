//
//  LCKEvent.m
//  Echoes
//
//  Created by Andrew Harrison on 12/27/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEvent.h"

@implementation LCKEvent

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        _name = name;
    }
    
    return self;
}

@end
