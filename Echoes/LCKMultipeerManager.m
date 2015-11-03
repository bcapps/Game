//
//  LCKMultipeerManager.m
//  Echoes
//
//  Created by Andrew Harrison on 12/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMultipeerManager.h"
#import "LCKDMManager.h"

#import "LCKServiceAdvertiser.h"
#import "LCKServiceBrowser.h"
#import "LCKMultipeerSession.h"

#import <LCKCategories/NSNotificationCenter+LCKAdditions.h>

NSString * const LCKMultipeerItemReceivedNotification = @"LCKMultipeerItemReceivedNotification";
NSString * const LCKMultipeerSoulsReceivedNotification = @"LCKMultipeerSoulsReceivedNotification";
NSString * const LCKMultipeerJournalEntryReceivedNotification = @"LCKMultipeerJournalEntryReceivedNotification";
NSString * const LCKMultipeerEventReceivedNotificiation = @"LCKMultipeerEventReceivedNotificiation";

NSString * const LCKMultipeerPeerStateChangedNotification = @"LCKMultipeerPeerStateChangedNotification";

NSString * const LCKMultipeerValueKey = @"value";

NSString * const LCKMultipeerJournalEntryTitle = @"entryTitle";
NSString * const LCKMultipeerJournalEntryDescription = @"entryDescription";

static NSString * const LCKMultipeerManagerServiceName = @"echoes";

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeJournalEntry,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeerManager () <LCKMultipeerSessionDelegate>

@property (nonatomic) NSString *characterName;

@property (nonatomic) LCKMultipeerSession *session;
@property (nonatomic) LCKServiceBrowser *serviceBrowser;
@property (nonatomic) LCKServiceAdvertiser *serviceAdvertiser;

@end

@implementation LCKMultipeerManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopSession];
}

- (instancetype)initWithCharacterName:(NSString *)characterName {
    NSParameterAssert(characterName);
    
    self = [super init];
    
    if (self) {
        _characterName = characterName;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSession) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSession) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

- (NSArray *)connectedPeers {
    return self.session.internalSession.connectedPeers;
}

- (void)startSession {
    [self instantiateMultipeerObjects];
    
    [self.serviceBrowser startBrowsing];
    [self.serviceAdvertiser beginAdvertising];
}

- (void)stopSession {
    [self.serviceBrowser stopBrowsing];
    [self.serviceAdvertiser stopAdvertising];
    
    [self.session.internalSession disconnect];
    
    [self tearDownMultipeerObjects];
}

- (void)instantiateMultipeerObjects {
    self.session = [[LCKMultipeerSession alloc] initWithPeerName:self.characterName delegate:self];

    if ([self.characterName isEqualToString:LCKDMDisplayName]) {
        self.serviceBrowser = [[LCKServiceBrowser alloc] initWithSession:self.session serviceName:LCKMultipeerManagerServiceName];
    }
    else {
        self.serviceAdvertiser = [[LCKServiceAdvertiser alloc] initWithSession:self.session serviceName:LCKMultipeerManagerServiceName];
    }
}

- (void)tearDownMultipeerObjects {
    self.serviceBrowser = nil;
    self.serviceAdvertiser = nil;
    self.session = nil;
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
        
        return [self.session.internalSession sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
    
    return NO;
}

- (BOOL)addJournalEntryWithEntryTitle:(NSString *)entryTitle entryDescription:(NSString *)entryDescription toPeerID:(MCPeerID *)peerID {
    if (peerID && entryTitle && entryDescription) {
        NSDictionary *dictionary = @{@"type": @(LCKMultipeerManagerSendTypeJournalEntry), @"entryTitle": entryTitle, @"entryDescription": entryDescription};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];

        return [self.session.internalSession sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:nil];
    }
    
    return NO;
}

- (void)session:(LCKMultipeerSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
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

- (void)session:(LCKMultipeerSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LCKMultipeerPeerStateChangedNotification object:nil];
    }];
}

@end
