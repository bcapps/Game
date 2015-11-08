//
//  LCKMultipeer+Messaging.m
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeer+Messaging.h"

NSString * const LCKMultipeerValueKey = @"value";

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerEventReceivedNotificiation = @"LCKMultipeerEventReceivedNotificiation";

@implementation LCKMultipeer (Messaging)

- (BOOL)sendItemName:(NSString *)itemName toPeerID:(MCPeerID *)peerID {
    return [self sendObject:itemName toPeerID:peerID sendType:LCKMultipeerManagerSendTypeItem];
}

- (BOOL)sendSoulAmount:(NSNumber *)souls toPeerID:(MCPeerID *)peerID {
    return [self sendObject:souls toPeerID:peerID sendType:LCKMultipeerManagerSendTypeSouls];
}

- (BOOL)sendEventName:(NSString *)eventName toPeerID:(MCPeerID *)peerID {
    return [self sendObject:eventName toPeerID:peerID sendType:LCKMultipeerManagerSendTypeEvent];
}

- (BOOL)sendObject:(id)object toPeerID:(MCPeerID *)peerID sendType:(LCKMultipeerManagerSendType)sendType {
    NSDictionary *dictionary = @{LCKMultipeerValueKey: object};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    LCKMultipeerMessage *message = [[LCKMultipeerMessage alloc] initWithMessageType:sendType messageData:data];
    
    return [self sendMessage:message toPeer:peerID];
}

@end
