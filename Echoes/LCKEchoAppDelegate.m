//
//  LCKEchoAppDelegate.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoAppDelegate.h"

#import "LCKEchoCoreDataController.h"

@interface LCKEchoAppDelegate ()

@end

@implementation LCKEchoAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LCKEchoCoreDataController registerSubclass:[LCKEchoCoreDataController class]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    self.window.tintColor = [UIColor whiteColor];
    
    return YES;
}

@end
