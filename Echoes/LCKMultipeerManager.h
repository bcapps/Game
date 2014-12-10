//
//  LCKMultipeerManager.h
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

extern NSString * const LCKMultipeerItemReceivedNotification;

@interface LCKMultipeerManager : NSObject

@property (nonatomic, readonly) MCSession *session;

- (instancetype)initWithCharacterName:(NSString *)characterName;

- (void)startMonitoring;
- (BOOL)sendItemName:(NSString *)itemName;

@end
