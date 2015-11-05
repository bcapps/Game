//
//  LCKMultipeer.m
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeer.h"

#import "LCKMultipeerSession.h"
#import "LCKMultipeerMessageSender.h"

#import "LCKServiceAdvertiser.h"
#import "LCKServiceBrowser.h"

@interface LCKMultipeer () <LCKMultipeerSessionDelegate>

@property (nonatomic) LCKMultipeerUserType userType;
@property (nonatomic) NSString *peerName;
@property (nonatomic) NSString *serviceName;
@property (nonatomic) id <LCKMultipeerDelegate> delegate;

@property (nonatomic) LCKMultipeerSession *session;
@property (nonatomic) LCKServiceAdvertiser *serviceAdvertiser;
@property (nonatomic) LCKServiceBrowser *serviceBrowser;
@property (nonatomic) LCKMultipeerMessageSender *messageSender;

@end

@implementation LCKMultipeer

#pragma mark - LCKMultipeer

- (instancetype)initWithMultipeerUserType:(LCKMultipeerUserType)userType peerName:(NSString *)peerName serviceName:(NSString *)serviceName delegate:(id <LCKMultipeerDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _userType = userType;
        _peerName = peerName;
        _serviceName = serviceName;
        _delegate = delegate;
    }
    
    return self;
}

- (void)startMultipeerConnectivity {
    switch (self.userType) {
        case LCKMultipeerUserTypeClient:
            [self.serviceAdvertiser beginAdvertising];
            break;
        case LCKMultipeerUserTypeHost:
            [self.serviceBrowser beginBrowsing];
            break;
    }
}

- (void)stopMultipeerConnectivity {
    switch (self.userType) {
        case LCKMultipeerUserTypeClient:
            [self.serviceAdvertiser stopAdvertising];
            self.serviceAdvertiser = nil;
            break;
        case LCKMultipeerUserTypeHost:
            [self.serviceBrowser stopBrowsing];
            self.serviceBrowser = nil;
            break;
    }
    
    [self.session.internalSession disconnect];
    self.session = nil;
}

- (BOOL)sendObject:(id <NSCoding>)object toPeer:(MCPeerID *)peerID {
    return [self.messageSender sendObject:object toPeerID:peerID];
}

- (BOOL)sendObjectToAllConnectedPeers:(id <NSCoding>)object {
    return [self.messageSender sendObjectToAllConnectedPeers:object];
}

- (NSArray *)connectedPeers {
    return self.session.internalSession.connectedPeers;
}

- (LCKMultipeerSession *)session {
    if (!_session) {
        _session = [[LCKMultipeerSession alloc] initWithPeerName:self.peerName delegate:self];
    }
    
    return _session;
}

- (LCKServiceBrowser *)serviceBrowser {
    if (self.userType != LCKMultipeerUserTypeHost) {
        return nil;
    }
    
    if (!_serviceBrowser) {
        _serviceBrowser = [[LCKServiceBrowser alloc] initWithSession:self.session serviceName:self.serviceName];
    }
    
    return _serviceBrowser;
}

- (LCKServiceAdvertiser *)serviceAdvertiser {
    if (self.userType != LCKMultipeerUserTypeClient) {
        return nil;
    }
    
    if (!_serviceAdvertiser) {
        _serviceAdvertiser = [[LCKServiceAdvertiser alloc] initWithSession:self.session serviceName:self.serviceName];
    }
    
    return _serviceAdvertiser;
}

- (LCKMultipeerMessageSender *)messageSender {
    if (!_messageSender) {
        _messageSender = [[LCKMultipeerMessageSender alloc] initWithMultipeerSession:self.session];
    }
    
    return _messageSender;
}

#pragma mark - LCKMultipeerSessionDelegate

- (void)session:(LCKMultipeerSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    if ([self.delegate respondsToSelector:@selector(objectReceived:fromPeer:)]) {
        id <NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate objectReceived:object fromPeer:peerID];
        }];
    }
}

- (void)session:(LCKMultipeerSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if ([self.delegate respondsToSelector:@selector(connectedPeersStateDidChange:)]) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate connectedPeersStateDidChange:self.connectedPeers];
        }];
    }
}

@end
