//
//  LCKServiceBrowser.h
//  Echoes
//
//  Created by Andrew Harrison on 11/2/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

@import Foundation;

@class LCKMultipeerSession;

@interface LCKServiceBrowser : NSObject

/**
 Initializes a service browser for the given session and service name;
 */
- (instancetype)initWithSession:(LCKMultipeerSession *)session serviceName:(NSString *)serviceName;

- (void)startBrowsing;

- (void)stopBrowsing;

@end
