//
//  LCKServiceAdvertiser.m
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import MultipeerConnectivity;

#import "LCKServiceAdvertiser.h"
#import "LCKMultipeerSession.h"

@interface LCKServiceAdvertiser () <MCNearbyServiceAdvertiserDelegate>

@property (nonatomic) NSString *serviceName;

@property (nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic) LCKMultipeerSession *session;

@end

@implementation LCKServiceAdvertiser

#pragma mark - LCKServiceAdvertiser

- (instancetype)initWithSession:(LCKMultipeerSession *)session serviceName:(NSString *)serviceName {
    self = [super init];
    
    if (self) {
        _session = session;
        _serviceName = serviceName;
    }
    
    return self;
}

- (MCNearbyServiceAdvertiser *)advertiser {
    if (!_advertiser) {
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.session.peerID discoveryInfo:nil serviceType:self.serviceName];
        _advertiser.delegate = self;
    }
    
    return _advertiser;
}

- (void)beginAdvertising {
    [self.advertiser startAdvertisingPeer];
}

- (void)stopAdvertising {
    [self.advertiser stopAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"Did receive invitation from %@", peerID.displayName);
    
    if (invitationHandler) {
        invitationHandler(YES, self.session.internalSession);
    }
}

@end
