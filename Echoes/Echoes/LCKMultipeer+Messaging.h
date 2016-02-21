//
//  LCKMultipeer+Messaging.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeer.h"

extern NSString * const LCKMultipeerValueKey;

extern NSString * const LCKMultipeerItemReceivedNotification;
extern NSString * const LCKMultipeerSoulsReceivedNotification;
extern NSString * const LCKMultipeerEventReceivedNotification;

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeer (Messaging)

- (BOOL)sendItemName:(NSString *)itemName toPeerID:(MCPeerID *)peerID;
- (BOOL)sendSoulAmount:(NSNumber *)souls toPeerID:(MCPeerID *)peerID;
- (BOOL)sendEventName:(NSString *)eventName toPeerID:(MCPeerID *)peerID;

@end
