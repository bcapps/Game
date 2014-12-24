//
//  LCKEchoNewCharacterViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoNewCharacterViewController.h"
#import "LCKEchoCoreDataController.h"
#import "CharacterClasses.h"
#import "Character.h"
#import "LCKCharacterPortrait.h"
#import "LCKStatCell.h"
#import "LCKInfoViewController.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <iCarousel/iCarousel.h>

#import <LCKCategories/NSManagedObject+LCKAdditions.h>
#import <LCKCategories/NSArray+LCKAdditions.h>

const CGFloat LCKEchoNewCharacterViewControllerNumberOfStats = 5;

CGFloat const LCKEchoNewCharacterViewControllerClassPickerVerticalOffset = -100;

CGFloat const LCKEchoNewCharacterViewControllerCarouselRadius = 135.0;
CGFloat const LCKEchoNewCharacterViewControllerCarouselItemSize = 90.0;

@interface LCKEchoNewCharacterViewController () <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *classPicker;

@property (nonatomic) NSArray *classes;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *characterNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *statsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classPickerHeightConstraint;

@end

@implementation LCKEchoNewCharacterViewController

#pragma mark - NSObject

- (void)dealloc {
    self.statsCollectionView.delegate = nil;
    self.statsCollectionView.dataSource = nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classPicker.type = iCarouselTypeWheel;
    self.classPicker.contentOffset = CGSizeMake(0, LCKEchoNewCharacterViewControllerClassPickerVerticalOffset);
    
    if (CGRectGetHeight(self.view.bounds) > 480.0) {
        self.classPickerHeightConstraint.constant = 350.0;
        [self.classPicker setNeedsUpdateConstraints];
    }
    
    self.characterNameTextField.textColor = [UIColor titleTextColor];
    self.characterNameTextField.font = [UIFont titleTextFontOfSize:16.0];
    self.characterNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Character Name" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor], NSFontAttributeName: self.characterNameTextField.font}];

    self.view.backgroundColor = [UIColor backgroundColor];
    self.classPicker.backgroundColor = [UIColor backgroundColor];
    
    self.classNameLabel.textColor = [UIColor titleTextColor];
    self.classDescriptionLabel.textColor = [UIColor descriptiveTextColor];
    
    self.classNameLabel.font = [UIFont titleTextFontOfSize:14.0];
    self.classDescriptionLabel.font = [UIFont descriptiveTextFontOfSize:12.0];

    [self.genderSegmentedControl addTarget:self action:@selector(genderSelected) forControlEvents:UIControlEventValueChanged];
    
    [self carouselCurrentItemIndexDidChange:self.classPicker];
    
    self.classPicker.backgroundColor = [UIColor redColor];
    [self.statsCollectionView registerClass:[LCKStatCell class] forCellWithReuseIdentifier:LCKStatCellReuseIdentifier];
    self.statsCollectionView.backgroundColor = [self.statsCollectionView.backgroundColor colorWithAlphaComponent:0.8];
}

- (NSArray *)classes {
    if (!_classes) {
        NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newMainQueueContext];
        
        Knight *knight = [[Knight alloc] initWithContext:context];
        Thief *thief = [[Thief alloc] initWithContext:context];
        Cleric *cleric = [[Cleric alloc] initWithContext:context];
        Warrior *warrior = [[Warrior alloc] initWithContext:context];
        Sorcerer *sorcerer = [[Sorcerer alloc] initWithContext:context];
        Bandit *bandit = [[Bandit alloc] initWithContext:context];
        Hunter *hunter = [[Hunter alloc] initWithContext:context];
        
        _classes = @[knight, thief, cleric, warrior, sorcerer, bandit, hunter];
    }
    
    return _classes;
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)button {
    NSManagedObjectContext *context = [LCKEchoCoreDataController sharedController].mainQueueContext;

    CharacterStats *selectedClass = [self.classes safeObjectAtIndex:self.classPicker.currentItemIndex];

    Character *newCharacter = [[Character alloc] initWithContext:context];
    newCharacter.name = self.characterNameTextField.text;
    newCharacter.characterStats = [[selectedClass class] newCharacterStatsInContext:context];
    newCharacter.currentHealth = newCharacter.maximumHealth;
    newCharacter.gender = @(self.genderSegmentedControl.selectedSegmentIndex);
    
    [[LCKEchoCoreDataController sharedController] saveContext:context];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)genderSelected {
    [self.classPicker reloadData];
}

#pragma mark - iCarouselDelegate

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionRadius) {
        return LCKEchoNewCharacterViewControllerCarouselRadius;
    }
    
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    CharacterStats *characterStats = [self.classes safeObjectAtIndex:carousel.currentItemIndex];
    
    self.classNameLabel.text = characterStats.className;
    self.classDescriptionLabel.text = characterStats.classDescription;
    
    [self.statsCollectionView reloadData];
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.classes.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CharacterStats *characterStats = [self.classes safeObjectAtIndex:index];

    LCKCharacterPortrait *portraitView = [[LCKCharacterPortrait alloc] initWithFrame:CGRectMake(0, 0, LCKEchoNewCharacterViewControllerCarouselItemSize, LCKEchoNewCharacterViewControllerCarouselItemSize)];
    portraitView.portraitImage = [characterStats classImageForGender:self.genderSegmentedControl.selectedSegmentIndex];
    
    return portraitView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return LCKEchoNewCharacterViewControllerNumberOfStats;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCKStatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCKStatCellReuseIdentifier forIndexPath:indexPath];
    
    NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newMainQueueContext];
    
    CharacterStats *characterStats = [[[self.classes safeObjectAtIndex:self.classPicker.currentItemIndex] class] newCharacterStatsInContext:context];

    cell.statNameLabel.text = [CharacterStats statNameForStatType:(LCKStatType)indexPath.row];
    cell.statValueLabel.text = [characterStats statAsStringForStatType:(LCKStatType)indexPath.row];
    
    return cell;
}

@end
