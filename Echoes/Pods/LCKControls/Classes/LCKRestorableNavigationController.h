//
//  LCKRestorableNavigationController.h
//  Velocity
//
//  Created by Matthew Bischoff on 7/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCKRestorableNavigationController : UINavigationController <UIViewControllerRestoration>

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController restorationIdentifier:(NSString *)restorationIdentifier;
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass restorationIdentifier:(NSString *)restorationIdentifier;

@end
