//
//  LCKMultipeerobjectSender.m
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import MultipeerConnectivity;

#import "LCKMultipeerMessageSender.h"
#import "LCKMultipeerSession.h"

@interface LCKMultipeerMessageSender ()

@property (nonatomic) LCKMultipeerSession *session;

@end

@implementation LCKMultipeerMessageSender

#pragma mark - LCKMultipeerobjectSender

- (instancetype)initWithMultipeerSession:(LCKMultipeerSession *)session {
    self = [super init];
    
    if (self) {
        _session = session;
    }
    
    return self;
}

- (BOOL)sendMessage:(LCKMultipeerMessage *)message toPeerID:(MCPeerID *)peerID {
    if (!peerID) {
        return NO;
    }
    
    return [self sendMessage:message toPeers:@[peerID]];
}

- (BOOL)sendMessageToAllConnectedPeers:(LCKMultipeerMessage *)message {
    return [self sendMessage:message toPeers:self.session.internalSession.connectedPeers];
}

- (BOOL)sendMessage:(LCKMultipeerMessage *)message toPeers:(NSArray *)peers {
    if (!message || !peers) {
        return NO;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    
    return [self.session.internalSession sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:nil];
}

@end
