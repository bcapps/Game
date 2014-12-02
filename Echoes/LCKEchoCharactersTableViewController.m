//
//  ViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoCharactersTableViewController.h"
#import "Character.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSManagedObject+LCKAdditions.h>

@interface LCKEchoCharactersTableViewController ()

@end

@implementation LCKEchoCharactersTableViewController

#pragma mark - LCKCoreDataTableViewController

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Character entityName]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

#pragma mark - LCKEchoCharactersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [UIView new];
}

@end
