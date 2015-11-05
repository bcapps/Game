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

- (BOOL)sendData:(NSData *)data toPeerID:(MCPeerID *)peerID {
    if (!peerID) {
        return NO;
    }
    
    return [self sendData:data toPeers:@[peerID]];
}

- (BOOL)sendDataToAllConnectedPeers:(NSData *)data {
    return [self sendData:data toPeers:self.session.internalSession.connectedPeers];
}

- (BOOL)sendData:(NSData *)data toPeers:(NSArray *)peers {
    if (!data) {
        return NO;
    }
    
    return [self.session.internalSession sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:nil];
}

@end
