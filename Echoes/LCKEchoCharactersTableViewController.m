//
//  ViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoCharactersTableViewController.h"
#import "LCKEchoCoreDataController.h"
#import "Character.h"
#import "CharacterClass.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import <LCKCategories/NSManagedObject+LCKAdditions.h>
#import <LCKCategories/NSFetchedResultsController+LCKAdditions.h>

@interface LCKEchoCharactersTableViewController ()

@end

@implementation LCKEchoCharactersTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [UIView new];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    Character *character = [self.fetchedResultsController safeObjectAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor backgroundColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - Level %@ %@", character.name, character.level, character.characterClass.className];
    cell.textLabel.textColor = [UIColor titleTextColor];
    cell.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showCharacterViewController" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Character *character = [self.fetchedResultsController safeObjectAtIndexPath:indexPath];
        
        NSManagedObjectContext *context = character.managedObjectContext;

        [context deleteObject:character];
        [[LCKEchoCoreDataController sharedController] saveContext:context];
    }
}

#pragma mark - LCKCoreDataTableViewController

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Character entityName]];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

@end
