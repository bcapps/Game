//
//  LCKCharacterViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/2/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKCharacterViewController.h"
#import "LCKStatCell.h"
#import "CharacterStats.h"
#import "LCKEchoCoreDataController.h"

#import "LCKInventoryTableViewController.h"
#import "LCKItemViewController.h"
#import "LCKItemProvider.h"
#import "LCKItemButton.h"
#import "LCKItem.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

typedef NS_ENUM(NSUInteger, LCKStatType) {
    LCKStatTypeVitality,
    LCKStatTypeStrength,
    LCKStatTypeDexterity,
    LCKStatTypeIntelligence,
    LCKStatTypeFaith
};

const CGFloat LCKCharacterViewControllerAnimationDuration = 0.3;
const CGFloat LCKItemViewControllerHorizontalMargin = 50.0;
const CGFloat LCKItemViewControllerVerticalMargin = 100.0;

@interface LCKCharacterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet LCKItemButton *helmetButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *chestButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *rightHandButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *firstAccessoryButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *secondAccessoryButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *bootsButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *leftHandButton;
@property (weak, nonatomic) IBOutlet UIImageView *silhouetteImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;

@property (strong, nonatomic) IBOutletCollection(LCKItemButton) NSArray *equipmentButtons;

@property (nonatomic) LCKItemViewController *currentlyPresentedItemViewController;
@property (nonatomic) UIView *overlayView;

@end

@implementation LCKCharacterViewController

#pragma mark - NSObject

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    self.title = self.character.name;
    
    [self setupSilhouetteGender];
    self.healthLabel.textColor = [UIColor colorWithRed:220.0/255.0 green:0 blue:10.0/255.0 alpha:1.0];
    self.healthLabel.font = [UIFont titleTextFontOfSize:15.0];
    
    [self updateHealthText];
    
    self.healthImageView.image = [self.healthImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.collectionView registerClass:[LCKStatCell class] forCellWithReuseIdentifier:LCKStatCellReuseIdentifier];
    
    LCKItem *item = [[LCKItemProvider allItems] firstObject];
    self.leftHandButton.itemImage = [UIImage imageNamed:item.imageName];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInventoryViewController"]) {
        LCKInventoryTableViewController *inventoryViewController = segue.destinationViewController;
        
        inventoryViewController.itemNames = self.character.items;
        inventoryViewController.equippedItemNames = self.character.equippedItems;
    }
}

#pragma mark - LCKCharacterViewController

- (void)updateHealthText {
    self.healthLabel.text = [NSString stringWithFormat:@"%@/%@", self.character.currentHealth, self.character.maximumHealth];
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentlyPresentedViewController)];
        
        [_overlayView addGestureRecognizer:dismissGesture];
    }
    
    return _overlayView;
}

- (CGRect)itemControllerFrame {
    return CGRectMake(LCKItemViewControllerHorizontalMargin, LCKItemViewControllerVerticalMargin, CGRectGetWidth(self.view.frame) - LCKItemViewControllerHorizontalMargin * 2, CGRectGetHeight(self.view.frame) - LCKItemViewControllerVerticalMargin * 2);
}

#pragma mark - Silhoutte

- (void)setupSilhouetteGender {
    if (self.character.characterGender == CharacterGenderMale) {
        self.silhouetteImageView.image = [UIImage imageNamed:@"SilhoutteMale"];
    }
    else {
        self.silhouetteImageView.image = [UIImage imageNamed:@"SilhoutteFemale"];
    }
}

#pragma mark - Equipment Buttons

- (LCKItemViewController *)newItemViewControllerForItem:(LCKItem *)item {
    LCKItemViewController *itemViewController = [[LCKItemViewController alloc] initWithItem:item];
    itemViewController.view.clipsToBounds = YES;
    
    return itemViewController;
}

- (void)presentItemViewControllerForItem:(LCKItem *)item fromButton:(UIButton *)button {
    LCKItemViewController *itemViewController = [self newItemViewControllerForItem:item];
    itemViewController.presentationFrame = button.frame;
    itemViewController.view.frame = [self itemControllerFrame];
    itemViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    self.overlayView.alpha = 0.0;
    [self.view addSubview:self.overlayView];
    [self addChildViewController:itemViewController];
    [self.view addSubview:itemViewController.view];
    [itemViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration animations:^{
        itemViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.overlayView.alpha = 1.0;
    }];
    
    self.currentlyPresentedItemViewController = itemViewController;
}

- (void)dismissCurrentlyPresentedViewController {
    [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration animations:^{
        self.overlayView.alpha = 0.0;
        self.currentlyPresentedItemViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [self.currentlyPresentedItemViewController willMoveToParentViewController:nil];
        [self.currentlyPresentedItemViewController.view removeFromSuperview];
        [self.currentlyPresentedItemViewController removeFromParentViewController];
    }];
}

- (IBAction)leftHandButtonTapped:(UIButton *)sender {
    [self presentItemViewControllerForItem:[[LCKItemProvider allItems] firstObject] fromButton:self.leftHandButton];
}

- (IBAction)rightHandbuttonTapped:(UIButton *)sender {
    
}

- (IBAction)helmetButtonTapped:(UIButton *)sender {
    
}

- (IBAction)chestButtonTapped:(UIButton *)sender {
    
}

- (IBAction)firstAccessoryButtonTapped:(UIButton *)sender {
    
}

- (IBAction)secondAccessoryButtonTapped:(UIButton *)sender {
    
}

- (IBAction)bootsButtonTapped:(UIButton *)sender {
    
}

- (IBAction)increaseHealthButtonTapped:(UIButton *)sender {
    if (self.character.currentHealth.integerValue + 1 > self.character.maximumHealth.integerValue) {
        return;
    }
    
    self.character.currentHealth = @(self.character.currentHealth.integerValue + 1);
    
    [self updateHealthText];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

- (IBAction)decreaseHealthButtonTapped:(UIButton *)sender {
    if (self.character.currentHealth.integerValue - 1 < 0) {
        return;
    }
    
    self.character.currentHealth = @(self.character.currentHealth.integerValue - 1);
    
    [self updateHealthText];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCKStatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCKStatCellReuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case LCKStatTypeVitality:
            cell.statNameLabel.text = @"VIT";
            cell.statValueLabel.text = [NSString stringWithFormat:@"%@", self.character.characterStats.vitality];
            break;
        case LCKStatTypeStrength:
            cell.statNameLabel.text = @"STR";
            cell.statValueLabel.text = [NSString stringWithFormat:@"%@", self.character.characterStats.strength];
            break;
        case LCKStatTypeDexterity:
            cell.statNameLabel.text = @"DEX";
            cell.statValueLabel.text = [NSString stringWithFormat:@"%@", self.character.characterStats.dexterity];
            break;
        case LCKStatTypeIntelligence:
            cell.statNameLabel.text = @"INT";
            cell.statValueLabel.text = [NSString stringWithFormat:@"%@", self.character.characterStats.intelligence];
            break;
        case LCKStatTypeFaith:
            cell.statNameLabel.text = @"FAI";
            cell.statValueLabel.text = [NSString stringWithFormat:@"%@", self.character.characterStats.faith];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

@end
