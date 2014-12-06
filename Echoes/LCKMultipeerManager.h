//
//  LCKMultipeerManager.h
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LCKMultipeerItemReceivedNotification;

@interface LCKMultipeerManager : NSObject

- (instancetype)initWithCharacterName:(NSString *)characterName;

- (void)startMonitoring;
- (void)sendItemName:(NSString *)itemName;

@end
