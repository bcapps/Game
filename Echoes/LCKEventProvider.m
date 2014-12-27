//
//  LCKEventProvider.m
//  Echoes
//
//  Created by Andrew Harrison on 12/27/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEventProvider.h"
#import "LCKEvent.h"

NSString * const LCKEventProviderRestAtBonfireEventName = @"Rest At Bonfire";

@implementation LCKEventProvider

+ (NSArray *)allEvents {
    static NSArray *events;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LCKEvent *bonfireEvent = [[LCKEvent alloc] initWithName:LCKEventProviderRestAtBonfireEventName];
        
        events = @[bonfireEvent];
    });
    
    return events;
}

@end
