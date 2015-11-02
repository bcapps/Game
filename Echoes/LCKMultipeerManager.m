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

typedef NS_ENUM(NSUInteger, LCKMultipeerManagerSendType) {
    LCKMultipeerManagerSendTypeItem,
    LCKMultipeerManagerSendTypeSouls,
    LCKMultipeerManagerSendTypeJournalEntry,
    LCKMultipeerManagerSendTypeEvent
};

@interface LCKMultipeerManager ()

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
        _session = [[LCKMultipeerSession alloc] initWithPeerName:characterName];
        
        if ([characterName isEqualToString:LCKDMDisplayName]) {
            _serviceBrowser = [[LCKServiceBrowser alloc] initWithSession:_session serviceName:@"echoes"];
        }
        else {
            _serviceAdvertiser = [[LCKServiceAdvertiser alloc] initWithSession:_session serviceName:@"echoes"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSession) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSession) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

- (NSArray *)connectedPeers {
    return self.session.internalSession.connectedPeers;
}

- (void)startSession {
    [self.serviceBrowser startBrowsing];
    [self.serviceAdvertiser beginAdvertising];
}

- (void)stopSession {
    [self.serviceBrowser stopBrowsing];
    [self.serviceAdvertiser stopAdvertising];
    
    [self.session.internalSession disconnect];
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

@end
