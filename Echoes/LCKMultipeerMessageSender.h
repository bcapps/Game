//
//  LCKMultipeerMessageSender.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

@class LCKMultipeerSession;

@interface LCKMultipeerMessageSender : NSObject

/**
*  Initializes the multipeer message sender with a given session.
*
*  @param session The session to initialize with.
*
*  @return An initialized multipeer message sender.
*/
- (instancetype)initWithMultipeerSession:(LCKMultipeerSession *)session;

/**
 *  Sends data through the multipeer session.
 *
 *  @param data   The data to send.
 *  @param peerID The peer ID to send the data to.
 *
 *  @return A BOOL indicating if the data was sent successfully.
 */
- (BOOL)sendData:(NSData *)data toPeerID:(MCPeerID *)peerID;

/**
 *  Sends data through the multipeer session to all peers
 *
 *  @param data The data to send.
 *
 *  @return A BOOL indicating if the data was sent successfully.
 */
- (BOOL)sendDataToAllConnectedPeers:(NSData *)data;

@end
