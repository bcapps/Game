//
//  LCKEventProvider.h
//  Echoes
//
//  Created by Andrew Harrison on 12/27/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;

extern NSString * const LCKEventProviderRestAtBonfireEventName;
extern NSString * const LCKEventProviderLevelUpEventName;

@interface LCKEventProvider : NSObject

+ (NSArray *)allEvents;

@end
