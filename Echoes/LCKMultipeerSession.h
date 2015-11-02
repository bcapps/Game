//
//  LCKMultipeerSession.h
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface LCKMultipeerSession : NSObject

@property (nonatomic, readonly) MCSession *internalSession;
@property (nonatomic, readonly) MCPeerID *peerID;

/**
 Initializes a multipeer session for the given peer name.
 
 @param peerName The display name of the peer.
 */
- (instancetype)initWithPeerName:(NSString *)peerName;

@end
