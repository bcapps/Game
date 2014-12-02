//
//  LCKDismissSegue.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKDismissSegue.h"

@implementation LCKDismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
