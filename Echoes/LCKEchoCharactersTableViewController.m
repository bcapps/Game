//
//  ViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoCharactersTableViewController.h"

@interface LCKEchoCharactersTableViewController ()

@end

@implementation LCKEchoCharactersTableViewController

#pragma mark - LCKCoreDataTableViewController

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@""];
    
    return fetchRequest;
}

@end
