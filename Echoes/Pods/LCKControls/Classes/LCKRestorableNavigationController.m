//
//  LCKRestorableNavigationController.m
//  Velocity
//
//  Created by Matthew Bischoff on 7/2/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKRestorableNavigationController.h"

static NSString * const LCKRestorableNavigationControllerNavigationBarClassKey = @"NavigationBarClassName";
static NSString * const LCKRestorableNavigationControllerToolbarClassKey = @"ToolbarClassName";

@implementation LCKRestorableNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController restorationIdentifier:(NSString *)restorationIdentifier {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInitializationForIdentifier:restorationIdentifier];
    }
    
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass restorationIdentifier:(NSString *)restorationIdentifier {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        [self commonInitializationForIdentifier:restorationIdentifier];
    }
    
    return self;
}

- (void)commonInitializationForIdentifier:(NSString *)identifier {
    self.restorationClass = [self class];
    self.restorationIdentifier = identifier;
}

#pragma mark - UIViewControllerRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:NSStringFromClass([self.navigationBar class]) forKey:LCKRestorableNavigationControllerNavigationBarClassKey];
    [coder encodeObject:NSStringFromClass([self.toolbar class]) forKey:LCKRestorableNavigationControllerToolbarClassKey];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    Class navigationBarClass = NSClassFromString([coder decodeObjectForKey:LCKRestorableNavigationControllerNavigationBarClassKey]);
    Class toolbarClass = NSClassFromString([coder decodeObjectForKey:LCKRestorableNavigationControllerToolbarClassKey]);
    
    LCKRestorableNavigationController *navigationController = [[self alloc] initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass restorationIdentifier:[identifierComponents lastObject]];
    return navigationController;
}

@end
