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
extern NSString * const LCKMultipeerSoulsReceivedNotification;
extern NSString * const LCKMultipeerJournalEntryReceivedNotification;
extern NSString * const LCKMultipeerEventReceivedNotificiation;

extern NSString * const LCKMultipeerPeerStateChangedNotification;
extern NSString * const LCKMultipeerValueKey;

extern NSString * const LCKMultipeerJournalEntryTitle;
extern NSString * const LCKMultipeerJournalEntryDescription;

@interface LCKMultipeerManager : NSObject

@property (nonatomic, readonly) NSArray *connectedPeers;

- (instancetype)initWithCharacterName:(NSString *)characterName;

- (void)startSession;
- (void)stopSession;

- (BOOL)sendItemName:(NSString *)itemName toPeerID:(MCPeerID *)peerID;
- (BOOL)sendSoulAmount:(NSNumber *)souls toPeerID:(MCPeerID *)peerID;
- (BOOL)sendEventName:(NSString *)eventName toPeerID:(MCPeerID *)peerID;

- (BOOL)addJournalEntryWithEntryTitle:(NSString *)entryTitle entryDescription:(NSString *)entryDescription toPeerID:(MCPeerID *)peerID;
@end
