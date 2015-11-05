//
//  LCKServiceBrowser.m
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import MultipeerConnectivity;

#import "LCKServiceBrowser.h"
#import "LCKMultipeerSession.h"

@interface LCKServiceBrowser () <MCNearbyServiceBrowserDelegate>

@property (nonatomic) LCKMultipeerSession *session;
@property (nonatomic) NSString *serviceName;

@property (nonatomic) MCNearbyServiceBrowser *serviceBrowser;

@end

@implementation LCKServiceBrowser

- (instancetype)initWithSession:(LCKMultipeerSession *)session serviceName:(NSString *)serviceName {
    self = [super init];
    
    if (self) {
        _session = session;
        _serviceName = serviceName;
    }
    
    return self;
}

- (MCNearbyServiceBrowser *)serviceBrowser {
    if (!_serviceBrowser) {
        _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.session.peerID serviceType:self.serviceName];
        _serviceBrowser.delegate = self;
    }
    
    return _serviceBrowser;
}

- (BOOL)shouldInvitePeer:(MCPeerID *)peerID {
    return ![peerID.displayName isEqualToString:self.session.peerID.displayName];
}

- (void)startBrowsing {
    [self.serviceBrowser startBrowsingForPeers];
}

- (void)stopBrowsing {
    [self.serviceBrowser stopBrowsingForPeers];
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"Found Peer %@", peerID.displayName);
    
    if ([self shouldInvitePeer:peerID]) {
        [browser invitePeer:peerID toSession:self.session.internalSession withContext:nil timeout:30];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Lost Peer %@", peerID.displayName);
}

@end
