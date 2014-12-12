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
#import "LCKStatusButton.h"

#import "LCKStatInfoViewController.h"
#import "LCKEquipmentViewController.h"

#import "LCKMultipeerManager.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

const CGFloat LCKCharacterViewControllerAnimationDuration = 0.3;
const CGFloat LCKItemViewControllerHorizontalMargin = 40.0;
const CGFloat LCKItemViewControllerVerticalMargin = 90.0;

const CGFloat LCKCharacterViewControllerNumberOfStats = 5;
const CGFloat LCKCharacterViewControllerStatHeight = 50.0;
const CGFloat LCKCharacterViewControllerFemaleFix = 40.0;

const CGFloat LCKCharacterStatInfoViewHorizontalMargin = 10.0;
const CGFloat LCKCharacterStatInfoViewHeight = 125.0;
const CGFloat LCKCharacterStatInfoViewBottomMargin = 10.0;

typedef void(^LCKItemViewControllerDismissCompletion)();

@interface LCKCharacterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, LCKItemViewControllerDelegate, LCKEquipmentViewControllerDelegate, LCKInventoryTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet LCKItemButton *helmetButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *chestButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *rightHandButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *firstAccessoryButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *secondAccessoryButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *bootsButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *leftHandButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *firstSpellButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *secondSpellButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *thirdSpellButton;
@property (weak, nonatomic) IBOutlet LCKItemButton *fourthSpellButton;

@property (weak, nonatomic) IBOutlet LCKStatusButton *soulsButton;

@property (weak, nonatomic) IBOutlet UIImageView *silhouetteImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *statsFlowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silhouetteWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silhouetteHeightConstraint;

@property (strong, nonatomic) IBOutletCollection(LCKItemButton) NSArray *equipmentButtons;

@property (nonatomic) UIViewController *currentlyPresentedItemViewController;
@property (nonatomic) UIView *overlayView;

@property (nonatomic) LCKMultipeerManager *multipeerManager;

@end

@implementation LCKCharacterViewController

#pragma mark - NSObject

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.multipeerManager = [[LCKMultipeerManager alloc] initWithCharacterName:self.character.name];
    [self.multipeerManager startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemReceived:) name:LCKMultipeerItemReceivedNotification object:nil];
    
    
    self.silhouetteHeightConstraint.constant = CGRectGetHeight(self.view.frame) * 0.65;
    self.silhouetteWidthConstraint.constant = self.silhouetteHeightConstraint.constant * (self.silhouetteImageView.image.size.width / self.silhouetteImageView.image.size.height);
    
    if (self.character.characterGender == CharacterGenderFemale) {
        self.silhouetteWidthConstraint.constant -= LCKCharacterViewControllerFemaleFix;
    }
    
    [self.view updateConstraintsIfNeeded];
    
    CGFloat itemSpacing = self.statsFlowLayout.minimumInteritemSpacing;
    CGFloat numberOfItems = LCKCharacterViewControllerNumberOfStats;
    
    self.statsFlowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.view.frame) - (itemSpacing * numberOfItems)) / numberOfItems, LCKCharacterViewControllerStatHeight);
    
    self.leftHandButton.itemSlot = LCKItemSlotOneHand;
    self.rightHandButton.itemSlot = LCKItemSlotOneHand;
    self.helmetButton.itemSlot = LCKItemSlotHelmet;
    self.chestButton.itemSlot = LCKItemSlotChest;
    self.bootsButton.itemSlot = LCKItemSlotBoots;
    
    self.firstAccessoryButton.itemSlot = LCKItemSlotAccessory;
    self.secondAccessoryButton.itemSlot = LCKItemSlotAccessory;

    self.firstSpellButton.itemSlot = LCKItemSlotSpell;
    self.secondSpellButton.itemSlot = LCKItemSlotSpell;
    self.thirdSpellButton.itemSlot = LCKItemSlotSpell;
    self.fourthSpellButton.itemSlot = LCKItemSlotSpell;
    
    [self.soulsButton setImage:[UIImage imageNamed:@"soulsIcon"] forState:UIControlStateNormal];
    [self.soulsButton setTitle:@"4000" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateItemButtons];
}

- (void)updateItemButtons {
    self.rightHandButton.item = [self.character.equippedWeapons firstObject];
    self.leftHandButton.item = [self.character.equippedWeapons safeObjectAtIndex:1];
    self.helmetButton.item = self.character.equippedHelm;
    self.chestButton.item = self.character.equippedChest;
    self.bootsButton.item = self.character.equippedBoots;
    
    self.firstSpellButton.item = self.character.equippedSpells.firstObject;
    self.secondSpellButton.item = [self.character.equippedSpells safeObjectAtIndex:1];
    self.thirdSpellButton.item = [self.character.equippedSpells safeObjectAtIndex:2];
    self.fourthSpellButton.item = [self.character.equippedSpells safeObjectAtIndex:3];

    self.firstAccessoryButton.item = [self.character.equippedAccessories firstObject];
    self.secondAccessoryButton.item = [self.character.equippedAccessories safeObjectAtIndex:1];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInventoryViewController"]) {
        LCKInventoryTableViewController *inventoryViewController = segue.destinationViewController;
        inventoryViewController.delegate = self;
        inventoryViewController.multipeerManager = self.multipeerManager;
        
        inventoryViewController.character = self.character;
    }
}

#pragma mark - LCKCharacterViewController

- (void)updateHealthText {
    self.healthLabel.text = [NSString stringWithFormat:@"%@/%@", self.character.currentHealth, self.character.maximumHealth];
    
    CGFloat healthPercentage = self.character.currentHealth.floatValue / self.character.maximumHealth.floatValue;
    
    if (healthPercentage > 0.66) {
        self.healthLabel.textColor = [UIColor greenHealthColor];
    }
    else if (healthPercentage > 0.33) {
        self.healthLabel.textColor = [UIColor yellowHealthColor];
    }
    else {
        self.healthLabel.textColor = [UIColor redColor];
    }
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTapped)];
        
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

#pragma mark - Stats

- (LCKStatInfoViewController *)newStatInfoViewControllerForStatType:(LCKStatType)statType {
    LCKStatInfoViewController *infoViewController = [[LCKStatInfoViewController alloc] init];
    infoViewController.statType = statType;
    infoViewController.view.clipsToBounds = YES;
    
    return infoViewController;
}

- (CGRect)statInfoViewFrameForCellFrame:(CGRect)cellFrame {
    return CGRectMake(LCKCharacterStatInfoViewHorizontalMargin, CGRectGetMinY(cellFrame) - LCKCharacterStatInfoViewHeight - LCKCharacterStatInfoViewBottomMargin, CGRectGetWidth(self.view.frame) - LCKCharacterStatInfoViewHorizontalMargin * 2, LCKCharacterStatInfoViewHeight);
}

#pragma mark - Equipment Buttons

- (LCKItemViewController *)newItemViewControllerForItem:(LCKItem *)item {
    LCKItemViewController *itemViewController = [[LCKItemViewController alloc] initWithItem:item displayStyle:LCKItemViewControllerDisplayStylePopup];
    itemViewController.delegate = self;
    itemViewController.character = self.character;
    itemViewController.view.clipsToBounds = YES;
    
    return itemViewController;
}

- (LCKEquipmentViewController *)newEquipmentViewControllerForEquipmentTypes:(NSArray *)equipmentTypes {
    LCKEquipmentViewController *equipmentViewController = [[LCKEquipmentViewController alloc] initWithCharacter:self.character equipmentTypes:equipmentTypes];
    equipmentViewController.delegate = self;
    equipmentViewController.view.clipsToBounds = YES;
    
    return equipmentViewController;
}

- (void)presentViewController:(UIViewController *)viewController withFrame:(CGRect)frame fromView:(UIView *)button {
    [self dismissCurrentlyPresentedViewController:^{
        viewController.view.frame = frame;
        viewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        self.overlayView.alpha = 0.0;
        [self.view addSubview:self.overlayView];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration animations:^{
            viewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.overlayView.alpha = 1.0;
        }];
        
        self.currentlyPresentedItemViewController = viewController;
    }];
}

- (void)overlayViewTapped {
    [self dismissCurrentlyPresentedViewController:nil];
}

- (void)dismissCurrentlyPresentedViewController:(LCKItemViewControllerDismissCompletion)completion {
    if (!self.currentlyPresentedItemViewController) {
        if (completion) {
            completion();
        }
    }
    else {
        [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration animations:^{
            self.overlayView.alpha = 0.0;
            self.currentlyPresentedItemViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [self.currentlyPresentedItemViewController willMoveToParentViewController:nil];
            [self.currentlyPresentedItemViewController.view removeFromSuperview];
            [self.currentlyPresentedItemViewController removeFromParentViewController];
            
            self.currentlyPresentedItemViewController = nil;
            
            if (completion) {
                completion();
            }
        }];
    }
}

- (IBAction)equipmentButtonTapped:(LCKItemButton *)button {
    UIViewController *viewController;
    
    if (button.item) {
        viewController = [self newItemViewControllerForItem:button.item];
    }
    else {
        NSArray *equipmentTypes;
        
        if (button == self.leftHandButton || button == self.rightHandButton) {
            equipmentTypes = @[@(LCKItemSlotOneHand), @(LCKItemSlotTwoHand)];
        }
        else if (button == self.firstAccessoryButton || button == self.secondAccessoryButton) {
            equipmentTypes = @[@(LCKItemSlotAccessory)];
        }
        else if (button == self.helmetButton) {
            equipmentTypes = @[@(LCKItemSlotHelmet)];
        }
        else if (button == self.chestButton) {
            equipmentTypes = @[@(LCKItemSlotChest)];
        }
        else if (button == self.bootsButton) {
            equipmentTypes = @[@(LCKItemSlotBoots)];
        }
        else if (button == self.firstSpellButton || button == self.secondSpellButton || button == self.thirdSpellButton || button == self.fourthSpellButton) {
            equipmentTypes = @[@(LCKItemSlotSpell)];
        }

        viewController = [self newEquipmentViewControllerForEquipmentTypes:equipmentTypes];
    }
    
    [self presentViewController:viewController withFrame:[self itemControllerFrame] fromView:button];
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

#pragma mark - Multipeer

- (void)itemReceived:(NSNotification *)notification {
    NSString *itemName = [notification.userInfo objectForKey:@"itemName"];
    
    LCKItem *item = [LCKItemProvider itemForName:itemName];
    
    [self.character addItemToInventory:item];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    LCKItemViewController *itemViewController = [self newItemViewControllerForItem:item];
    
    [self presentViewController:itemViewController withFrame:[self itemControllerFrame] fromView:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return LCKCharacterViewControllerNumberOfStats;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCKStatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCKStatCellReuseIdentifier forIndexPath:indexPath];
    
    cell.statNameLabel.text = [CharacterStats statNameForStatType:(LCKStatType)indexPath.row];
    cell.statValueLabel.text = [self.character.characterStats statAsStringForStatType:(LCKStatType)indexPath.row];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCKStatInfoViewController *infoViewController = [self newStatInfoViewControllerForStatType:indexPath.row];
    
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellFrame = [self.view convertRect:selectedCell.frame fromView:collectionView];
    
    CGRect presentationFrame = [self statInfoViewFrameForCellFrame:cellFrame];
    
    infoViewController.presentingRect = CGRectMake(cellFrame.origin.x - LCKCharacterStatInfoViewHorizontalMargin, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.width);
    
    [self presentViewController:infoViewController withFrame:presentationFrame fromView:selectedCell];
}

#pragma mark - LCKItemViewControllerDelegate

- (void)unequipButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    [self.character unequipItem:itemViewController.item];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self updateItemButtons];
    [self dismissCurrentlyPresentedViewController:nil];
}

#pragma mark - LCKEquipmentViewControllerDelegate

- (void)itemWasSelected:(LCKItem *)item {
    [self.character equipItem:item];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self updateItemButtons];
    [self dismissCurrentlyPresentedViewController:nil];
}

#pragma mark - LCKInventoryTableViewControllerDelegate

- (void)itemWasGiftedFromInventory:(LCKItem *)item {
    [self.navigationController popToViewController:self animated:YES];
    
    [self.character removeItemFromInventory:item];
}

@end
