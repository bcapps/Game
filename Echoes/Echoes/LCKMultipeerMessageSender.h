//
//  LCKMultipeerMessageSender.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

#import "LCKMultipeerMessage.h"

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
 *  Sends a message through the multipeer session.
 *
 *  @param message   The message to send.
 *  @param peerID    The peer ID to send the data to.
 *
 *  @return A BOOL indicating if the message was sent successfully.
 */
- (BOOL)sendMessage:(LCKMultipeerMessage *)message toPeerID:(MCPeerID *)peerID;

/**
 *  Sends a message through the multipeer session to all peers
 *
 *  @param message The message to send.
 *
 *  @return A BOOL indicating if the message was sent successfully.
 */
- (BOOL)sendMessageToAllConnectedPeers:(LCKMultipeerMessage *)message;

@end
