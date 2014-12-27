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

#import "LCKBaseCell.h"

#import "LCKEchoCoreDataController.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKEquipmentViewController ()

@property (nonatomic) Character *character;
@property (nonatomic) NSArray *equipmentTypes;

@property (nonatomic, readonly) NSArray *itemsToDisplay;
@property (nonatomic) UILabel *noItemsLabel;

@end

@implementation LCKEquipmentViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.cornerRadius = 8.0;
    self.tableView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tableView.layer.borderWidth = 1.0;

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.itemsToDisplay.count == 0) {
        self.noItemsLabel = [[UILabel alloc] init];
        self.noItemsLabel.textAlignment = NSTextAlignmentCenter;
        self.noItemsLabel.text = [self emptyText];
        self.noItemsLabel.textColor = [UIColor descriptiveTextColor];
        self.noItemsLabel.font = [UIFont descriptiveTextFontOfSize:20.0];
        self.noItemsLabel.numberOfLines = 0;
        
        [self.tableView addSubview:self.noItemsLabel];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect labelFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    self.noItemsLabel.frame = labelFrame;
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

- (NSString *)emptyText {
    if ([self.equipmentTypes containsObject:@(LCKItemSlotOneHand)]) {
        return @"No Usable Weapons";
    }
    else if ([self.equipmentTypes containsObject:@(LCKItemSlotHelmet)]) {
        return @"No Usable Helmets";
    }
    else if ([self.equipmentTypes containsObject:@(LCKItemSlotChest)]) {
        return @"No Usables Chests";
    }
    else if ([self.equipmentTypes containsObject:@(LCKItemSlotAccessory)]) {
        return @"No Usable Accessories";
    }
    else if ([self.equipmentTypes containsObject:@(LCKItemSlotBoots)]) {
        return @"No Usable Boots";
    }
    else if ([self.equipmentTypes containsObject:@(LCKItemSlotSpell)]) {
        return @"No Usable Spells or Miracles";
    }
    
    return @"";
}

- (NSArray *)itemsToDisplay {
    NSMutableArray *items = [NSMutableArray array];
    
    for (LCKItem *item in self.character.items) {
        if (!item.isEquipped) {
            for (NSNumber *typeNumber in self.equipmentTypes) {
                LCKItemSlot slot = [typeNumber integerValue];
                
                if ([item isAppropriateForItemSlot:slot] && [self.character meetsRequirementsForItem:item]) {
                    [items addObject:item];
                    break;
                }
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
    LCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    LCKItem *item = [self.itemsToDisplay safeObjectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKItem *item = [self.itemsToDisplay safeObjectAtIndex:indexPath.row];

    [self.delegate itemWasSelected:item equipmentSlot:self.selectedEquipmentSlot];
}

@end
