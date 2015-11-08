//
//  LCKHockeyReporter.m
//  Echoes
//
//  Created by Andrew Harrison on 11/8/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKHockeyController.h"

#import <HockeySDK/HockeySDK.h>

@implementation LCKHockeyController

- (void)startReporting {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"2e1122a4b5aaea239b30e91d5c7983c7"];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

@end
