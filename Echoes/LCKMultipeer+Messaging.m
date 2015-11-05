//
//  LCKMultipeer+Messaging.m
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeer+Messaging.h"

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerJournalEntryReceivedNotification = @"LCKMultipeerJournalEntryReceivedNotification";
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
    NSDictionary *dictionary = @{@"value": object};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    LCKMultipeerMessage *message = [[LCKMultipeerMessage alloc] initWithMessageType:sendType messageData:data];
    
    return [self sendMessage:message toPeer:peerID];
}

- (void)receiveMessage:(LCKMultipeerMessage *)message {
    NSString *notificationName;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:message.data options:0 error:nil];
    
    if (message.type == LCKMultipeerManagerSendTypeItem) {
        notificationName = LCKMultipeerItemReceivedNotification;
    }
    else if (message.type == LCKMultipeerManagerSendTypeSouls) {
        notificationName = LCKMultipeerSoulsReceivedNotification;
    }
    else if (message.type == LCKMultipeerManagerSendTypeJournalEntry) {
        notificationName = LCKMultipeerJournalEntryReceivedNotification;
    }
    else if (message.type == LCKMultipeerManagerSendTypeEvent) {
        notificationName = LCKMultipeerEventReceivedNotificiation;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:dictionary];
}

@end
