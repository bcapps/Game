//
//  LCKMultipeerManager.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMultipeerManager.h"

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerJournalEntryReceivedNotification = @"LCKMultipeerJournalEntryReceivedNotification";
NSString * const LCKMultipeerEventReceivedNotificiation = @"LCKMultipeerEventReceivedNotificiation";

NSString * const LCKMultipeerPeerStateChangedNotification = @"LCKMultipeerPeerStateChangedNotification";

NSString * const LCKMultipeerSoulsKey = @"soulAmount";
NSString * const LCKMultipeerItemKey = @"itemName";

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
    
    if (![peerID.displayName isEqualToString:self.characterName]) {
        [browser invitePeer:peerID toSession:self.session withContext:nil timeout:30];
    }
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
    if (certificateHandler) {
        certificateHandler(YES);
    }
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer State Changed");
    
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
        
        if (type == LCKMultipeerManagerSendTypeItem) {
            NSString *itemName = [dictionary objectForKey:@"value"];
            
            if (itemName) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerItemReceivedNotification object:nil userInfo:@{LCKMultipeerItemKey: itemName}];
                }];
            }
        }
        else if (type == LCKMultipeerManagerSendTypeSouls) {
            NSNumber *souls = [dictionary objectForKey:@"value"];
            
            if (souls) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerSoulsReceivedNotification object:nil userInfo:@{LCKMultipeerSoulsKey: souls}];
                }];
            }
        }
        else if (type == LCKMultipeerManagerSendTypeJournalEntry) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerJournalEntryReceivedNotification object:nil userInfo:dictionary];
            }];
        }
        else if (type == LCKMultipeerManagerSendTypeEvent) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerEventReceivedNotificiation object:nil userInfo:dictionary];
            }];
        }
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
