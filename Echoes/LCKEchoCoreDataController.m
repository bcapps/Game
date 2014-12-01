//
//  LCKEchoCoreDataController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoCoreDataController.h"

@implementation LCKEchoCoreDataController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.modelURLResourceString = @"Echoes";
    }
    
    return self;
}

@end
