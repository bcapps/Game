//
//  LCKMultipeerMessage.h
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

@interface LCKMultipeerMessage : NSObject <NSCoding>

/**
 *  The type of message to send. This can be used to identify what type of message is received.
 */
@property (nonatomic, readonly) NSUInteger type;

/**
 *  The data to send.
 */
@property (nonatomic, readonly) NSData *data;

/**
 *  Initializes a message.
 *
 *  @param type The type of message to send.
 *  @param data        The data to send.
 *
 *  @return An initialized message.
 */
- (instancetype)initWithMessageType:(NSUInteger)type messageData:(NSData *)data;

@end
