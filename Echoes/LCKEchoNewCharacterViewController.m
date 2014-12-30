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
#import "LCKStatsCollectionViewController.h"
#import "LCKStatInfoViewController.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"
#import "UIViewController+Presentation.h"

#import <iCarousel/iCarousel.h>

#import <LCKCategories/NSManagedObject+LCKAdditions.h>
#import <LCKCategories/NSArray+LCKAdditions.h>

const CGFloat LCKEchoNewCharacterViewControllerNumberOfStats = 5;

CGFloat const LCKEchoNewCharacterViewControllerClassPickerVerticalOffset = -100;

CGFloat const LCKEchoNewCharacterViewControllerCarouselRadius = 135.0;
CGFloat const LCKEchoNewCharacterViewControllerCarouselItemSize = 90.0;

@interface LCKEchoNewCharacterViewController () <iCarouselDelegate, iCarouselDataSource, UITextFieldDelegate, LCKStatsCollectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *classPicker;

@property (nonatomic) NSArray *classes;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *characterNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classPickerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) LCKStatsCollectionViewController *statsCollectionViewController;

@property (nonatomic) UIViewController *currentlyDisplayedViewController;
@property (nonatomic) UIView *overlayView;

@end

@implementation LCKEchoNewCharacterViewController

#pragma mark - NSObject

- (void)dealloc {
    self.characterNameTextField.delegate = nil;
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
    
    self.characterNameTextField.delegate = self;
    self.doneButton.enabled = NO;
    
    self.overlayView.hidden = YES;
    [self.view addSubview:self.overlayView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"StatsCollectionViewEmbed"]) {
        self.statsCollectionViewController = segue.destinationViewController;
        
        NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newMainQueueContext];
        CharacterStats *characterStats = [[[self.classes safeObjectAtIndex:self.classPicker.currentItemIndex] class] newCharacterStatsInContext:context];

        self.statsCollectionViewController.displayedStats = characterStats;
        self.statsCollectionViewController.delegate = self;
    }
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
    
    [self.characterNameTextField resignFirstResponder];
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
    
    [self.statsCollectionViewController.collectionView reloadData];
    [self.characterNameTextField resignFirstResponder];
    
    NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newMainQueueContext];
    CharacterStats *newCharacterStats = [[[self.classes safeObjectAtIndex:self.classPicker.currentItemIndex] class] newCharacterStatsInContext:context];

    self.statsCollectionViewController.displayedStats = newCharacterStats;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = textField.text.length - range.length + string.length;
   
    if (length > 0) {
        self.doneButton.enabled = YES;
    }
    else {
        self.doneButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - LCKStatsCollectionViewControllerDelegate

- (void)statItemWasTappedForStatType:(LCKStatType)statType selectedCell:(UICollectionViewCell *)selectedCell {
    LCKInfoViewController *infoViewController = [[LCKInfoViewController alloc] init];
    infoViewController.arrowDirection = UIPopoverArrowDirectionDown;
    
    CGRect cellFrame = [self.view convertRect:selectedCell.frame fromView:self.statsCollectionViewController.collectionView];
    
    infoViewController.presentingRect = CGRectMake(cellFrame.origin.x - LCKStatInfoViewHorizontalMargin, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.width);
    
    [self presentViewController:infoViewController currentlyPresentedViewController:self.currentlyDisplayedViewController withFrame:[self statInfoViewFrameForCellFrame:cellFrame] fromView:selectedCell];
    self.currentlyDisplayedViewController = infoViewController;
    
    self.overlayView.hidden = NO;
    
    infoViewController.titleLabel.text = [CharacterStats statTitleForStatType:statType];
    infoViewController.infoTextView.text = [CharacterStats statDescriptionForStatType:statType];
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        _overlayView.clipsToBounds = NO;
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTapped)];
        
        [_overlayView addGestureRecognizer:dismissGesture];
    }
    
    return _overlayView;
}

- (void)overlayViewTapped {
    [self dismissCurrentlyPresentedViewController:self.currentlyDisplayedViewController animationBlock:^{
        self.overlayView.alpha = 0.02;
    } withCompletion:^{
        self.currentlyDisplayedViewController = nil;
        
        self.overlayView.hidden = YES;
        self.overlayView.alpha = 1.0;
    }];
}

- (CGRect)statInfoViewFrameForCellFrame:(CGRect)cellFrame {
    return CGRectMake(LCKStatInfoViewHorizontalMargin, CGRectGetMinY(cellFrame) - LCKStatInfoViewHeight - LCKStatInfoViewBottomMargin, CGRectGetWidth(self.view.frame) - LCKStatInfoViewHorizontalMargin * 2, LCKStatInfoViewHeight);
}
@end
