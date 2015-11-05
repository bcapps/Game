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
#import "LCKMultipeer+Messaging.h"

NSString * const LCKMultipeerPeerStateChangedNotification = @"LCKMultipeerPeerStateChangedNotification";

static NSString * const LCKMultipeerManagerServiceName = @"echoes";

@interface LCKMultipeerManager () <LCKMultipeerDelegate>

@property (nonatomic) LCKMultipeer *multipeer;

@end

@implementation LCKMultipeerManager

- (instancetype)initWithCharacterName:(NSString *)characterName {
    NSParameterAssert(characterName);
    
    self = [super init];
    
    if (self) {
        LCKMultipeerUserType userType = LCKMultipeerUserTypeClient;
        
        if ([LCKDMManager isDMMode]) {
            userType = LCKMultipeerUserTypeHost;
        }
        
        _multipeer = [[LCKMultipeer alloc] initWithMultipeerUserType:userType peerName:characterName serviceName:@"echoes" delegate:self];
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
    return [self.multipeer sendItemName:itemName toPeerID:peerID];
}

- (BOOL)sendSoulAmount:(NSNumber *)souls toPeerID:(MCPeerID *)peerID {
    return [self.multipeer sendSoulAmount:souls toPeerID:peerID];
}

- (BOOL)sendEventName:(NSString *)eventName toPeerID:(MCPeerID *)peerID {
    return [self.multipeer sendEventName:eventName toPeerID:peerID];
}

- (void)multipeer:(LCKMultipeer *)multipeer receivedMessage:(LCKMultipeerMessage *)message fromPeer:(MCPeerID *)peer {
    [multipeer receiveMessage:message];
}

- (void)multipeer:(LCKMultipeer *)multipeer connectedPeersStateDidChange:(NSArray *)connectedPeers {
    [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerPeerStateChangedNotification object:nil];
}

@end
