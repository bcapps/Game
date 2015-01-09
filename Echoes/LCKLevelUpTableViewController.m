//
//  LCKLevelUpTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 1/8/15.
//  Copyright (c) 2015 Lickability. All rights reserved.
//

#import "LCKLevelUpTableViewController.h"
#import "LCKBaseCell.h"

#import "CharacterStats.h"
#import "LCKEchoCoreDataController.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

const CGFloat LCKLevelUpTableViewControllerNumberOfStats = 5;
const CGFloat LCKLevelUpTableViewControllerSectionHeaderHeight = 38.0;

@interface LCKLevelUpTableViewController ()

@property (nonatomic) Character *character;
@property (nonatomic) NSArray *increaseButtonArray;

@property (nonatomic) UIButton *selectedButton;

@end

@implementation LCKLevelUpTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.scrollEnabled = NO;
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = 8.0;
    self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.view.layer.borderWidth = 1.0;
    
    self.increaseButtonArray = @[];
    
    for (NSUInteger buttonIndex = 0; buttonIndex < LCKLevelUpTableViewControllerNumberOfStats; buttonIndex++) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0, 44.0, 44.0)];
        [addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        self.increaseButtonArray = [self.increaseButtonArray arrayByAddingObject:addButton];
    }
    
    self.tableView.rowHeight = 46.0;
}

- (void)addButtonTapped:(UIButton *)button {
    self.selectedButton = button;
    
    [self.tableView reloadData];
}

#pragma mark - LCKLevelUpTableViewController

- (instancetype)initWithCharacter:(Character *)character {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelUpController"];
    
    if (self) {
        _character = character;
    }
    
    return self;
}

- (void)levelUpButtonTapped {
    NSUInteger statIndex = [self.increaseButtonArray indexOfObject:self.selectedButton];
    
    [self.character.characterStats addStatValue:1 forStatType:statIndex];
    [self.character increaseLevel];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self.delegate levelUpButtonTappedForController:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return LCKLevelUpTableViewControllerNumberOfStats;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    UIButton *increaseButton = [self.increaseButtonArray safeObjectAtIndex:indexPath.row];
    
    BOOL statIsSelected = increaseButton == self.selectedButton;
        
    cell.accessoryView = increaseButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSNumber *statValue = [self.character.characterStats statValueForStatType:indexPath.row];
    
    if (statIsSelected) {
        statValue = @(statValue.integerValue + 1);
        [increaseButton setImage:[[UIImage imageNamed:@"LevelUpIconFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    else {
        [increaseButton setImage:[[UIImage imageNamed:@"LevelUpCircleEmpty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    NSString *statText = [NSString stringWithFormat:@"%@     %@", [CharacterStats statNameForStatType:indexPath.row], statValue.stringValue];
    
    cell.textLabel.text = statText;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LCKLevelUpTableViewControllerSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), LCKLevelUpTableViewControllerSectionHeaderHeight)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    
    UIButton *levelUpButton = [[UIButton alloc] initWithFrame:headerView.bounds];
    [levelUpButton setTitle:@"Level Up" forState:UIControlStateNormal];
    [levelUpButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
    [levelUpButton setTitleColor:[UIColor descriptiveTextColor] forState:UIControlStateHighlighted];
    [levelUpButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    levelUpButton.titleLabel.font = [UIFont titleTextFontOfSize:16.0];
    levelUpButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [levelUpButton addTarget:self action:@selector(levelUpButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.selectedButton) {
        levelUpButton.enabled = NO;
    }
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(levelUpButton.frame) - 1.0, CGRectGetWidth(levelUpButton.frame), 1.0)];
    separatorLine.backgroundColor = [UIColor descriptiveTextColor];
    
    [headerView addSubview:levelUpButton];
    [headerView addSubview:separatorLine];
    
    return headerView;
}

@end
