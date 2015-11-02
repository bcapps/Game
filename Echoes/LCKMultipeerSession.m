//
//  LCKMultipeerSession.m
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeerSession.h"
#import "LCKMultipeerManager.h"

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeJournalEntry,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeerSession () <MCSessionDelegate>

@property (nonatomic) NSString *peerName;

@property (nonatomic) MCSession *internalSession;
@property (nonatomic) MCPeerID *peerID;

@end

@implementation LCKMultipeerSession

- (instancetype)initWithPeerName:(NSString *)peerName {
    self = [super init];
    
    if (self) {
        _peerName = peerName;
    }
    
    return self;
}

- (MCPeerID *)peerID {
    if (!_peerID) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:self.peerName];
    }
    
    return _peerID;
}

- (MCSession *)internalSession {
    if (!_internalSession) {
        _internalSession = [[MCSession alloc] initWithPeer:self.peerID];
        _internalSession.delegate = self;
    }
    
    return _internalSession;
}

#pragma mark - MCSessionDelegate

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
