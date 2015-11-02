//
//  LCKServiceAdvertiser.h
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

@class LCKMultipeerSession;

@interface LCKServiceAdvertiser : NSObject

/**
 Initializes a service advertiser with the given peer name and service name.
 
 @param session The session to advertise on.
 @param serviceName The name of the service to advertise for.
 */
- (instancetype)initWithSession:(LCKMultipeerSession *)session serviceName:(NSString *)serviceName;

/**
 Begin advertising this peer to others.
 */
- (void)beginAdvertising;

/**
 Stop advertising this peer to others.
 */
- (void)stopAdvertising;

@end
