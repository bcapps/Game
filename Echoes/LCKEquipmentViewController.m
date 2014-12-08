//
//  LCKEquipmentViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/7/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEquipmentViewController.h"
#import "Character.h"
#import "LCKItem.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKEquipmentViewController ()

@property (nonatomic) Character *character;
@property (nonatomic) NSArray *equipmentTypes;

@property (nonatomic, readonly) NSArray *itemsToDisplay;

@end

@implementation LCKEquipmentViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.cornerRadius = 8.0;
    self.tableView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tableView.layer.borderWidth = 1.0;

    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - LCKEquipmentViewController

- (instancetype)initWithCharacter:(Character *)character equipmentTypes:(NSArray *)equipmentTypes {
    self = [super init];
    
    if (self) {
        _character = character;
        _equipmentTypes = equipmentTypes;
    }
    
    return self;
}

- (NSArray *)itemsToDisplay {
    NSMutableArray *items = [NSMutableArray array];
    
    for (LCKItem *item in self.character.items) {
        for (NSNumber *typeNumber in self.equipmentTypes) {
            LCKItemSlot slot = [typeNumber integerValue];
            
            if ([item isAppropriateForItemSlot:slot]) {
                [items addObject:item];
                break;
            }
        }
    }
    
    return items;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsToDisplay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    LCKItem *item = [self.itemsToDisplay safeObjectAtIndex:indexPath.row];
    
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = item.name;
    cell.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor titleTextColor];
    
    return cell;
}


@end
