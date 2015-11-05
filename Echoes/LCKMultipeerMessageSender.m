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

- (BOOL)sendObject:(id <NSCoding>)object toPeerID:(MCPeerID *)peerID {
    if (!peerID) {
        return NO;
    }
    
    return [self sendObject:object toPeers:@[peerID]];
}

- (BOOL)sendObjectToAllConnectedPeers:(id <NSCoding>)object {
    return [self sendObject:object toPeers:self.session.internalSession.connectedPeers];
}

- (BOOL)sendObject:(id <NSCoding>)object toPeers:(NSArray *)peers {
    if (!object || !peers) {
        return NO;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    return [self.session.internalSession sendData:data toPeers:peers withMode:MCSessionSendDataReliable error:nil];
}

@end
