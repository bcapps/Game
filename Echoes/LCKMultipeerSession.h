//
//  LCKMultipeerSession.h
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@class LCKMultipeerSession;

@protocol LCKMultipeerSessionDelegate <NSObject>

@optional
- (void)session:(LCKMultipeerSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
- (void)session:(LCKMultipeerSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler;
- (void)session:(LCKMultipeerSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
- (void)session:(LCKMultipeerSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;
- (void)session:(LCKMultipeerSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
- (void)session:(LCKMultipeerSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;

@end

@interface LCKMultipeerSession : NSObject

@property (nonatomic, readonly) MCSession *internalSession;
@property (nonatomic, readonly) MCPeerID *peerID;

/**
 Initializes a multipeer session for the given peer name.
 
 @param peerName The display name of the peer.
 */
- (instancetype)initWithPeerName:(NSString *)peerName delegate:(id <LCKMultipeerSessionDelegate>)delegate;

@end
