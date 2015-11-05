//
//  LCKMultipeerManager.h
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

extern NSString * const LCKMultipeerPeerStateChangedNotification;

@interface LCKMultipeerManager : NSObject

@property (nonatomic, readonly) NSArray *connectedPeers;

- (instancetype)initWithCharacterName:(NSString *)characterName;

- (void)startSession;
- (void)stopSession;

- (BOOL)sendItemName:(NSString *)itemName toPeerID:(MCPeerID *)peerID;
- (BOOL)sendSoulAmount:(NSNumber *)souls toPeerID:(MCPeerID *)peerID;
- (BOOL)sendEventName:(NSString *)eventName toPeerID:(MCPeerID *)peerID;

@end
