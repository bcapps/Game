//
//  LCKMultipeerManager.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMultipeerManager.h"
#import "LCKDMManager.h"

#import <LCKCategories/NSNotificationCenter+LCKAdditions.h>

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerJournalEntryReceivedNotification = @"LCKMultipeerJournalEntryReceivedNotification";
NSString * const LCKMultipeerEventReceivedNotificiation = @"LCKMultipeerEventReceivedNotificiation";

NSString * const LCKMultipeerPeerStateChangedNotification = @"LCKMultipeerPeerStateChangedNotification";

NSString * const LCKMultipeerValueKey = @"value";

NSString * const LCKMultipeerJournalEntryTitle = @"entryTitle";
NSString * const LCKMultipeerJournalEntryDescription = @"entryDescription";

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeJournalEntry,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeerManager () <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (nonatomic) NSString *characterName;

@property (nonatomic) MCNearbyServiceBrowser *serviceBrowser;
@property (nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic) MCPeerID *localPeerID;
@property (nonatomic) MCSession *session;
@property (nonatomic) NSDate *timeStarted;

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
        
        if (_characterName.length) {
            _localPeerID = [[MCPeerID alloc] initWithDisplayName:_characterName];
            
            _session = [[MCSession alloc] initWithPeer:_localPeerID];
            _session.delegate = self;
            
            if ([LCKDMManager isDMMode]) {
                _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_localPeerID serviceType:@"echoes"];
                _serviceBrowser.delegate = self;
            }

            _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_localPeerID discoveryInfo:nil serviceType:@"echoes"];
            _serviceAdvertiser.delegate = self;
        }
    }
    
    return self;
}

- (void)startMonitoring {
    if (self.characterName.length > 0) {
        [self.serviceBrowser startBrowsingForPeers];
        [self.serviceAdvertiser startAdvertisingPeer];
        
        _timeStarted = [NSDate date];
    }
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
    if (object && peerID) {
        NSDictionary *dictionary = @{@"type": @(sendType), @"value": object};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        
        return [self.session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
    
    return NO;
}

- (BOOL)addJournalEntryWithEntryTitle:(NSString *)entryTitle entryDescription:(NSString *)entryDescription toPeerID:(MCPeerID *)peerID {
    if (peerID && entryTitle && entryDescription) {
        NSDictionary *dictionary = @{@"type": @(LCKMultipeerManagerSendTypeJournalEntry), @"entryTitle": entryTitle, @"entryDescription": entryDescription};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];

        return [self.session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
    
    return NO;
}

#pragma mark - MCNearbyServiceBrowserDelegate

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"Found Peer %@", peerID.displayName);
    
    if ([self shouldInvitePeer:peerID]) {
        [browser invitePeer:peerID toSession:self.session withContext:nil timeout:30];
    }
}

- (BOOL)shouldInvitePeer:(MCPeerID *)peerID {
    return ![peerID.displayName isEqualToString:self.characterName] && [LCKDMManager isDMMode];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Lost Peer");
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"Did Receive Invitiation From Peer");
    
    BOOL shouldAcceptInvitation = ![LCKDMManager isDMMode];
    
    if (invitationHandler) {
        invitationHandler(shouldAcceptInvitation, self.session);
    }
    
    if (shouldAcceptInvitation) {
        [self.serviceBrowser stopBrowsingForPeers];
        [self.serviceAdvertiser stopAdvertisingPeer];
    }
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
    if (certificateHandler) {
        certificateHandler(YES);
    }
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerPeerStateChangedNotification object:nil];
    }];
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"Did Receive Data");

    if (data) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        LCKMultipeerManagerSendType type = [[dictionary objectForKey:@"type"] integerValue];
        
        NSString *notificationName;
        
        if (type == LCKMultipeerManagerSendTypeItem) {
            notificationName = LCKMultipeerItemReceivedNotification;
        }
        else if (type == LCKMultipeerManagerSendTypeSouls) {
            notificationName = LCKMultipeerSoulsReceivedNotification;
        }
        else if (type == LCKMultipeerManagerSendTypeJournalEntry) {
            notificationName = LCKMultipeerJournalEntryReceivedNotification;
        }
        else if (type == LCKMultipeerManagerSendTypeEvent) {
            notificationName = LCKMultipeerEventReceivedNotificiation;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:dictionary];
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
