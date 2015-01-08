//
//  LCKEchoAppDelegate.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoAppDelegate.h"

#import "LCKEchoCoreDataController.h"
#import <HockeySDK/HockeySDK.h>

#import <HockeySDK/BITHockeyManager.h>
#import <HockeySDK/BITCrashManager.h>

@interface LCKEchoAppDelegate ()

@end

@implementation LCKEchoAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"2e1122a4b5aaea239b30e91d5c7983c7"];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    [LCKEchoCoreDataController registerSubclass:[LCKEchoCoreDataController class]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    self.window.tintColor = [UIColor whiteColor];
    
    application.idleTimerDisabled = YES;
    
    return YES;
}

@end
