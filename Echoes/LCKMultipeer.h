//
//  LCKMultipeer.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

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
@protocol LCKMultipeerDelegate <NSObject>

@optional

/**
 *  This delegate method is called when an object is received from another peer in the same session.
 *
 *  @param object The object that is received.
 *  @param peer   The peer that sent it.
 */
- (void)objectReceived:(id <NSCoding>)object fromPeer:(MCPeerID *)peer;

/**
 *  This delegate method is called when the state of one or more peers has changed in the session.
 *
 *  @param connectedPeers The current peers that are connected to the session.
 */
- (void)connectedPeersStateDidChange:(NSArray *)connectedPeers;

@end

@interface LCKMultipeer : NSObject

/**
 *  Returns an array of peers connected to the current session.
 */
@property (nonatomic, readonly) NSArray *connectedPeers;

/**
 *  The user type this instance was initialized with.
 */
@property (nonatomic, readonly) LCKMultipeerUserType userType;

/**
 *  The delegate this instance was initialized with.
 */
@property (nonatomic, readonly) id <LCKMultipeerDelegate> delegate;

/**
 *  Initializes the multipeer object with the specified user type.
 *
 *  @param userType The type of user this multipeer object will represent.
 *  @param peerName The display name to user for this peer.
 *  @param serviceName The service this multipeer object will represent.
 *  @param delegate The delegate of the multipeer object.
 *
 *  @return An initialized multipeer instance.
 */
- (instancetype)initWithMultipeerUserType:(LCKMultipeerUserType)userType peerName:(NSString *)peerName serviceName:(NSString *)serviceName delegate:(id <LCKMultipeerDelegate>)delegate;

/**
 *  Call this method to enable multipeer connectivity.
 */
- (void)startMultipeerConnectivity;

/**
 *  Call this method to disable multipeer connectivity.
 */
- (void)stopMultipeerConnectivity;

/**
 *  Sends a specified object to the specified peer.
 *
 *  @param object The object you wish the peer to receive.
 *  @param peerID The peer you wish to receive the object.
 *
 *  @return A BOOL indicating if the send was successful.
 */
- (BOOL)sendObject:(id <NSCoding>)object toPeer:(MCPeerID *)peerID;

/**
 *  Sends an object to all connected peers.
 *
 *  @param object The object you wish to send.
 *
 *  @return A BOOL indicating if the send was successful.
 */
- (BOOL)sendObjectToAllConnectedPeers:(id <NSCoding>)object;

@end
