//
//  LCKMultipeer.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@class LCKMultipeer;

#import "LCKMultipeerMessage.h"

/**
 *  The type of user this multipeer object should be representing.
 */
typedef NS_ENUM(NSUInteger, LCKMultipeerUserType) {
    /**
     *  This option represents a user acting as a client wishing to join a session. They will advertise their ability to join services of the specified name.
     */
    LCKMultipeerUserTypeClient,
    /**
     *  This options represents a user acting as a host wishing to invite clients to join a session. They will seek out, and automatically invite users advertising their ability to join the specified service.
     */
    LCKMultipeerUserTypeHost
};

/**
 *  A multipeer delegate protocol used for communicating change or information received from other peers. These delegate methods are guaranteed to be run on the main queue.
 */
@protocol LCKMultipeerEventListener <NSObject>

@optional

/**
 *  This delegate method is called when a message is received from another peer in the same session.
 *
 *  @param message The message that is received.
 *  @param peer   The peer that sent it.
 */
- (void)multipeer:(LCKMultipeer *)multipeer receivedMessage:(LCKMultipeerMessage *)message fromPeer:(MCPeerID *)peer;

/**
 *  This delegate method is called when the state of one or more peers has changed in the session.
 *
 *  @param connectedPeers The current peers that are connected to the session.
 */
- (void)multipeer:(LCKMultipeer *)multipeer connectedPeersStateDidChange:(NSArray *)connectedPeers;

@end

@interface LCKMultipeer : NSObject

/**
 *  Returns an array of peers connected to the current session.
 */
@property (nonatomic, readonly) NSArray <MCPeerID *> *connectedPeers;

/**
 *  The user type this instance was initialized with.
 */
@property (nonatomic, readonly) LCKMultipeerUserType userType;

/**
 *  Initializes the multipeer object with the specified user type.
 *
 *  @param userType The type of user this multipeer object will represent.
 *  @param peerName The display name to user for this peer.
 *  @param serviceName The service this multipeer object will represent.
 *
 *  @return An initialized multipeer instance.
 */
- (instancetype)initWithMultipeerUserType:(LCKMultipeerUserType)userType peerName:(NSString *)peerName serviceName:(NSString *)serviceName;

/**
 *  Call this method to enable multipeer connectivity.
 */
- (void)startMultipeerConnectivity;

/**
 *  Call this method to disable multipeer connectivity.
 */
- (void)stopMultipeerConnectivity;

/**
 *  Adds an event listener to the multipeer session.
 *
 *  @param eventListener The event listener to add.
 */
- (void)addEventListener:(id <LCKMultipeerEventListener>)eventListener;

/**
 *  Removes an event listener from the multipeer session.
 *
 *  @param eventListener The event listener to remove.
 */
- (void)removeEventListener:(id <LCKMultipeerEventListener>)eventListener;

/**
 *  Sends a specified message to the specified peer.
 *
 *  @param message The message you wish the peer to receive.
 *  @param peerID  The peer you wish to receive the message.
 *
 *  @return A BOOL indicating if the send was successful.
 */
- (BOOL)sendMessage:(LCKMultipeerMessage *)message toPeer:(MCPeerID *)peerID;

/**
 *  Sends a message to all connected peers.
 *
 *  @param message The message you wish to send.
 *
 *  @return A BOOL indicating if the send was successful.
 */
- (BOOL)sendMessageToAllConnectedPeers:(LCKMultipeerMessage *)message;

@end
