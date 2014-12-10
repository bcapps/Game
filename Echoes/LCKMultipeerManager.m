//
//  LCKMultipeerManager.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMultipeerManager.h"

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";

@interface LCKMultipeerManager () <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (nonatomic) NSString *characterName;

@property (nonatomic) MCNearbyServiceBrowser *serviceBrowser;
@property (nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic) MCSession *session;

@end

@implementation LCKMultipeerManager

- (void)dealloc {
    [self.serviceBrowser stopBrowsingForPeers];
    [self.serviceAdvertiser stopAdvertisingPeer];
    
    [self.session disconnect];
}

- (instancetype)initWithCharacterName:(NSString *)characterName {
    self = [super init];
    
    if (self) {
        _characterName = characterName;
    }
    
    return self;
}

- (void)startMonitoring {
    if (self.characterName.length > 0) {
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:self.characterName];
        
        self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:@"echoes"];
        self.serviceBrowser.delegate = self;
        [self.serviceBrowser startBrowsingForPeers];
        
        self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:@{} serviceType:@"echoes"];
        self.serviceAdvertiser.delegate = self;
        [self.serviceAdvertiser startAdvertisingPeer];
        
        self.session = [[MCSession alloc] initWithPeer:peerID];
        self.session.delegate = self;
    }
}

- (BOOL)sendItemName:(NSString *)itemName {
    return [self.session sendData:[itemName dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
}

#pragma mark - MCNearbyServiceBrowserDelegate

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"Found Peer");
    
    [browser invitePeer:peerID toSession:self.session withContext:nil timeout:30];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Lost Peer");
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"Did Receive Invitiation From Peer");

    if (invitationHandler) {
        invitationHandler(YES, self.session);
    }
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
    certificateHandler(YES);
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer State Changed");
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"Did Receive Data");

    NSString *itemName = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (itemName) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerItemReceivedNotification object:nil userInfo:@{@"itemName": itemName}];
        }];
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@"Did Receive Stream");
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"Did Start Resource");
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"Did Finish Resource");
}

@end
