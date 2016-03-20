//
//  LCKMultipeerSession.m
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeerSession.h"

@interface LCKMultipeerSession () <MCSessionDelegate>

@property (nonatomic) NSString *peerName;
@property (nonatomic) id <LCKMultipeerSessionDelegate> delegate;

@property (nonatomic) MCSession *internalSession;
@property (nonatomic) MCPeerID *peerID;

@end

@implementation LCKMultipeerSession

- (instancetype)initWithPeerName:(NSString *)peerName delegate:(id<LCKMultipeerSessionDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _peerName = peerName;
        _delegate = delegate;
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

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    if ([self.delegate respondsToSelector:@selector(session:didReceiveData:fromPeer:)]) {
        [self.delegate session:self didReceiveData:data fromPeer:peerID];
    }
}

//- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
//    if ([self.delegate respondsToSelector:@selector(session:didReceiveCertificate:fromPeer:certificateHandler:)]) {
//        [self.delegate session:self didReceiveCertificate:certificate fromPeer:peerID certificateHandler:certificateHandler];
//    }
//    else if (certificateHandler) {
//        certificateHandler(YES);
//    }
//}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if ([self.delegate respondsToSelector:@selector(session:peer:didChangeState:)]) {
        [self.delegate session:self peer:peerID didChangeState:state];
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    if ([self.delegate respondsToSelector:@selector(session:didReceiveStream:withName:fromPeer:)]) {
        [self.delegate session:self didReceiveStream:stream withName:streamName fromPeer:peerID];
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    if ([self.delegate respondsToSelector:@selector(session:didStartReceivingResourceWithName:fromPeer:withProgress:)]) {
        [self.delegate session:self didStartReceivingResourceWithName:resourceName fromPeer:peerID withProgress:progress];
    }
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:)]) {
        [self.delegate session:self didFinishReceivingResourceWithName:resourceName fromPeer:peerID atURL:localURL withError:error];
    }
}

@end
