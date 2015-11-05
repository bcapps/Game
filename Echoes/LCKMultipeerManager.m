//
//  LCKMultipeerManager.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMultipeerManager.h"
#import "LCKDMManager.h"

#import "LCKMultipeer.h"

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerJournalEntryReceivedNotification = @"LCKMultipeerJournalEntryReceivedNotification";
NSString * const LCKMultipeerEventReceivedNotificiation = @"LCKMultipeerEventReceivedNotificiation";

NSString * const LCKMultipeerPeerStateChangedNotification = @"LCKMultipeerPeerStateChangedNotification";

NSString * const LCKMultipeerValueKey = @"value";

NSString * const LCKMultipeerJournalEntryTitle = @"entryTitle";
NSString * const LCKMultipeerJournalEntryDescription = @"entryDescription";

static NSString * const LCKMultipeerManagerServiceName = @"echoes";

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeJournalEntry,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeerManager () <LCKMultipeerDelegate>

@property (nonatomic) LCKMultipeer *multipeer;

@end

@implementation LCKMultipeerManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopSession];
}

- (instancetype)initWithCharacterName:(NSString *)characterName {
    NSParameterAssert(characterName);
    
    self = [super init];
    
    if (self) {
        LCKMultipeerUserType userType = LCKMultipeerUserTypeClient;
        
        if ([LCKDMManager isDMMode]) {
            userType = LCKMultipeerUserTypeHost;
        }
        
        _multipeer = [[LCKMultipeer alloc] initWithMultipeerUserType:userType peerName:characterName serviceName:@"echoes" delegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSession) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSession) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

- (NSArray *)connectedPeers {
    return self.multipeer.connectedPeers;
}

- (void)startSession {
    [self.multipeer startMultipeerConnectivity];
}

- (void)stopSession {
    [self.multipeer stopMultipeerConnectivity];
}

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
    
    return [self.multipeer sendMessage:message toPeer:peerID];
}


- (void)multipeer:(LCKMultipeer *)multipeer receivedMessage:(LCKMultipeerMessage *)message fromPeer:(MCPeerID *)peer {
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

- (void)multipeer:(LCKMultipeer *)multipeer connectedPeersStateDidChange:(NSArray *)connectedPeers {
    [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerPeerStateChangedNotification object:nil];
}

@end
