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

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <iCarousel/iCarousel.h>

#import <LCKCategories/NSManagedObject+LCKAdditions.h>
#import <LCKCategories/NSArray+LCKAdditions.h>

CGFloat const LCKEchoNewCharacterViewControllerClassPickerVerticalOffset = -100;
CGFloat const LCKEchoNewCharacterViewControllerCarouselRadius = 135.0;
CGFloat const LCKEchoNewCharacterViewControllerCarouselItemSize = 90.0;

@interface LCKEchoNewCharacterViewController () <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *classPicker;

@property (nonatomic, readonly) NSArray *classes;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *characterNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;

@end

@implementation LCKEchoNewCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classPicker.type = iCarouselTypeWheel;
    self.classPicker.contentOffset = CGSizeMake(0, LCKEchoNewCharacterViewControllerClassPickerVerticalOffset);
    
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
}

- (NSArray *)classes {
    NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newMainQueueContext];
    
    Knight *knight = [[Knight alloc] initWithContext:context];
    Thief *thief = [[Thief alloc] initWithContext:context];
    Cleric *cleric = [[Cleric alloc] initWithContext:context];
    Warrior *warrior = [[Warrior alloc] initWithContext:context];
    Sorcerer *sorcerer = [[Sorcerer alloc] initWithContext:context];
    Bandit *bandit = [[Bandit alloc] initWithContext:context];
    Hunter *hunter = [[Hunter alloc] initWithContext:context];
    
    return @[knight, thief, cleric, warrior, sorcerer, bandit, hunter];
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

@end
