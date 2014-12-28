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
#import "LCKEventProvider.h"

#import "LCKInfoViewController.h"
#import "LCKEquipmentViewController.h"

#import "LCKMultipeerManager.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>
#import <UICountingLabel/UICountingLabel.h>

const CGFloat LCKCharacterViewControllerAnimationDuration = 0.4;
const CGFloat LCKItemViewControllerHorizontalMargin = 45.0;
const CGFloat LCKItemViewControllerVerticalMargin = 100.0;

const CGFloat LCKCharacterViewControllerNumberOfStats = 5;
const CGFloat LCKCharacterViewControllerStatHeight = 50.0;
const CGFloat LCKCharacterViewControllerFemaleFix = 40.0;

const CGFloat LCKCharacterStatInfoViewHorizontalMargin = 10.0;
const CGFloat LCKCharacterStatInfoViewHeight = 145.0;
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
@property (weak, nonatomic) IBOutlet UIButton *increaseHealthButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseHealthButton;
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
    
    self.multipeerManager = [[LCKMultipeerManager alloc] initWithCharacterName:self.character.displayName];
    [self.multipeerManager startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemReceived:) name:LCKMultipeerItemReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soulsReceived:) name:LCKMultipeerSoulsReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventReceived:) name:LCKMultipeerEventReceivedNotificiation object:nil];
    
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
    self.soulsButton.soulLabel.method = UILabelCountingMethodLinear;
    self.soulsButton.soulLabel.format = @"%d";
    [self.soulsButton.soulLabel countFromCurrentValueTo:self.character.souls.floatValue withDuration:0.0];
    
    [self.soulsButton addTarget:self action:@selector(didSelectSoulsButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.increaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:self.character.maximumHealth];
    self.decreaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:@(0)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateItemButtons];
}

- (void)updateItemButtons {
    self.leftHandButton.item = nil;
    self.rightHandButton.item = nil;
    self.firstSpellButton.item = nil;
    self.secondSpellButton.item = nil;
    self.thirdSpellButton.item = nil;
    self.fourthSpellButton.item = nil;
    self.firstAccessoryButton.item = nil;
    self.secondAccessoryButton.item = nil;
    
    for (LCKItem *weapon in self.character.equippedWeapons) {
        if (weapon.equippedSlot == LCKEquipmentSlotLeftHand) {
            self.leftHandButton.item = weapon;
        }
        else if (weapon.equippedSlot == LCKEquipmentSlotRightHand) {
            self.rightHandButton.item = weapon;
        }
    }

    self.helmetButton.item = self.character.equippedHelm;
    self.chestButton.item = self.character.equippedChest;
    self.bootsButton.item = self.character.equippedBoots;
    
    for (LCKItem *spell in self.character.equippedSpells) {
        if (spell.equippedSlot == LCKEquipmentSlotFirstSpell) {
            self.firstSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotSecondSpell) {
            self.secondSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotThirdSpell) {
            self.thirdSpellButton.item = spell;
        }
        else if (spell.equippedSlot == LCKEquipmentSlotFourthSpell) {
            self.fourthSpellButton.item = spell;
        }
    }
    
    for (LCKItem *accessory in self.character.equippedAccessories) {
        if (accessory.equippedSlot == LCKEquipmentSlotFirstAccessory) {
            self.firstAccessoryButton.item = accessory;
        }
        else if (accessory.equippedSlot == LCKEquipmentSlotSecondAccessory) {
            self.secondAccessoryButton.item = accessory;
        }
    }    
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
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
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

- (LCKInfoViewController *)newInfoViewController {
    LCKInfoViewController *infoViewController = [[LCKInfoViewController alloc] init];
    
    return infoViewController;
}

- (CGRect)infoViewFrameForStatusFrame:(CGRect)statusFrame {
    return CGRectMake(LCKCharacterStatInfoViewHorizontalMargin, CGRectGetMaxY(statusFrame), CGRectGetWidth(self.view.frame) - LCKCharacterStatInfoViewHorizontalMargin * 2, LCKCharacterStatInfoViewHeight - 40.0);
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

- (LCKEquipmentViewController *)newEquipmentViewControllerForEquipmentTypes:(NSArray *)equipmentTypes equipmentSlot:(LCKEquipmentSlot)equipmentSlot {
    LCKEquipmentViewController *equipmentViewController = [[LCKEquipmentViewController alloc] initWithCharacter:self.character equipmentTypes:equipmentTypes];
    equipmentViewController.delegate = self;
    equipmentViewController.view.clipsToBounds = YES;
    equipmentViewController.selectedEquipmentSlot = equipmentSlot;
    
    return equipmentViewController;
}

- (void)presentViewController:(UIViewController *)viewController withFrame:(CGRect)frame fromView:(UIView *)button {
    if (!viewController) {
        return;
    }
    
    [self dismissCurrentlyPresentedViewController:^{
        viewController.view.frame = frame;
        viewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        self.overlayView.alpha = 0.0;
        [self.view addSubview:self.overlayView];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.overlayView.alpha = 1.0;
        } completion:nil];
        
        self.currentlyPresentedItemViewController = viewController;
        self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    }];
}

- (void)overlayViewTapped {
    [self dismissCurrentlyPresentedViewController:nil];
}

- (void)dismissCurrentlyPresentedViewController:(LCKItemViewControllerDismissCompletion)completion {
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    self.navigationController.navigationBar.tintColor = self.view.window.tintColor;

    if (!self.currentlyPresentedItemViewController) {
        self.overlayView.alpha = 0.0;
        
        if (completion) {
            completion();
        }
    }
    else {
        UIViewController *presentedViewController = self.currentlyPresentedItemViewController;
        self.currentlyPresentedItemViewController = nil;
        
        [UIView animateWithDuration:LCKCharacterViewControllerAnimationDuration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.overlayView.alpha = 0.0;
            presentedViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [presentedViewController willMoveToParentViewController:nil];
            [presentedViewController.view removeFromSuperview];
            [presentedViewController removeFromParentViewController];
                        
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)didSelectSoulsButton {
    LCKInfoViewController *infoViewController = [self newInfoViewController];
    infoViewController.presentingRect = self.soulsButton.frame;
    infoViewController.arrowDirection = UIPopoverArrowDirectionUp;
    
    [self presentViewController:infoViewController withFrame:[self infoViewFrameForStatusFrame:self.soulsButton.frame] fromView:self.soulsButton];

    infoViewController.infoTextView.text = @"· Souls are gained by defeating powerful enemies and absorbing their souls.\n· Souls can be used to level up.\n· Souls can be used to purchase items.";
}

- (IBAction)equipmentButtonTapped:(LCKItemButton *)button {
    UIViewController *viewController;
    
    if (button.item) {
        viewController = [self newItemViewControllerForItem:button.item];
    }
    else {
        NSArray *equipmentTypes;
        LCKEquipmentSlot equipmentSlot = LCKEquipmentSlotUnequipped;
        
        if (button == self.leftHandButton || button == self.rightHandButton) {
            if (button == self.leftHandButton) {
                equipmentSlot = LCKEquipmentSlotLeftHand;
            }
            else {
                equipmentSlot = LCKEquipmentSlotRightHand;
            }
            
            equipmentTypes = @[@(LCKItemSlotOneHand), @(LCKItemSlotTwoHand)];
        }
        else if (button == self.firstAccessoryButton || button == self.secondAccessoryButton) {
            if (button == self.firstAccessoryButton) {
                equipmentSlot = LCKEquipmentSlotFirstAccessory;
            }
            else {
                equipmentSlot = LCKEquipmentSlotSecondAccessory;
            }
            
            equipmentTypes = @[@(LCKItemSlotAccessory)];
        }
        else if (button == self.helmetButton) {
            equipmentSlot = LCKEquipmentSlotHelmet;
            equipmentTypes = @[@(LCKItemSlotHelmet)];
        }
        else if (button == self.chestButton) {
            equipmentSlot = LCKEquipmentSlotChest;
            equipmentTypes = @[@(LCKItemSlotChest)];
        }
        else if (button == self.bootsButton) {
            equipmentSlot = LCKEquipmentSlotBoots;
            equipmentTypes = @[@(LCKItemSlotBoots)];
        }
        else if (button == self.firstSpellButton || button == self.secondSpellButton || button == self.thirdSpellButton || button == self.fourthSpellButton) {
            
            if (button == self.firstSpellButton) {
                equipmentSlot = LCKEquipmentSlotFirstSpell;
            }
            else if (button == self.secondSpellButton) {
                equipmentSlot = LCKEquipmentSlotSecondSpell;
            }
            else if (button == self.thirdSpellButton) {
                equipmentSlot = LCKEquipmentSlotThirdSpell;
            }
            else {
                equipmentSlot = LCKEquipmentSlotFourthSpell;
            }
            
            equipmentTypes = @[@(LCKItemSlotSpell)];
        }

        viewController = [self newEquipmentViewControllerForEquipmentTypes:equipmentTypes equipmentSlot:equipmentSlot];
    }
    
    [self presentViewController:viewController withFrame:[self itemControllerFrame] fromView:button];
}

- (IBAction)increaseHealthButtonTapped:(UIButton *)sender {
    if (self.character.currentHealth.integerValue + 1 > self.character.maximumHealth.integerValue) {
        return;
    }
    
    self.character.currentHealth = @(self.character.currentHealth.integerValue + 1);
    
    self.increaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:self.character.maximumHealth];
    self.decreaseHealthButton.enabled = YES;
    
    [self updateHealthText];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

- (IBAction)decreaseHealthButtonTapped:(UIButton *)sender {
    if (self.character.currentHealth.integerValue - 1 < 0) {
        return;
    }
    
    self.character.currentHealth = @(self.character.currentHealth.integerValue - 1);
    
    self.decreaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:@(0)];
    self.increaseHealthButton.enabled = YES;
    
    [self updateHealthText];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

#pragma mark - Multipeer

- (void)itemReceived:(NSNotification *)notification {
    NSString *itemName = [notification.userInfo objectForKey:LCKMultipeerItemKey];
    
    LCKItem *item = [LCKItemProvider itemForName:itemName];
    
    [self.character addItemToInventory:item];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    LCKItemViewController *itemViewController = [self newItemViewControllerForItem:item];
    
    [self presentViewController:itemViewController withFrame:[self itemControllerFrame] fromView:nil];
}

- (void)soulsReceived:(NSNotification *)notification {
    NSNumber *souls = [notification.userInfo objectForKey:LCKMultipeerSoulsKey];
    NSNumber *newAmount = @(self.character.souls.integerValue + souls.integerValue);
    
    [self.soulsButton.soulLabel countFromCurrentValueTo:newAmount.floatValue withDuration:1.5];
    
    self.character.souls = newAmount;
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

- (void)eventReceived:(NSNotification *)notification {
    NSString *eventName = [notification.userInfo objectForKey:@"value"];
    
    if ([eventName isEqualToString:LCKEventProviderRestAtBonfireEventName]) {
        LCKItem *emptyFlask;
        
        for (LCKItem *item in self.character.items) {
            if ([item.name isEqualToString:@"Empty Flask"]) {
                emptyFlask = item;
                break;
            }
        }
        
        self.character.currentHealth = self.character.maximumHealth;
        
        self.increaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:self.character.maximumHealth];
        self.decreaseHealthButton.enabled = YES;

        if (emptyFlask) {
            LCKItem *healingFlask = [LCKItemProvider itemForName:@"Healing Flask"];
            healingFlask.equipped = emptyFlask.equipped;
            healingFlask.equippedSlot = emptyFlask.equippedSlot;
            
            [self.character removeItemFromInventory:emptyFlask];
            [self.character addItemToInventory:healingFlask];

            [self updateItemButtons];
        }
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
        [self updateHealthText];
    }
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
    LCKInfoViewController *infoViewController = [self newInfoViewController];
    infoViewController.arrowDirection = UIPopoverArrowDirectionDown;

    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellFrame = [self.view convertRect:selectedCell.frame fromView:collectionView];
    
    CGRect presentationFrame = [self statInfoViewFrameForCellFrame:cellFrame];
    
    infoViewController.presentingRect = CGRectMake(cellFrame.origin.x - LCKCharacterStatInfoViewHorizontalMargin, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.width);
    
    [self presentViewController:infoViewController withFrame:presentationFrame fromView:selectedCell];
    
    infoViewController.titleLabel.text = [CharacterStats statTitleForStatType:indexPath.row];
    infoViewController.infoTextView.text = [CharacterStats statDescriptionForStatType:indexPath.row];
}

#pragma mark - LCKItemViewControllerDelegate

- (void)unequipButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    [self.character unequipItem:itemViewController.item];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self updateItemButtons];
    [self dismissCurrentlyPresentedViewController:nil];
}

- (void)useItemButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    LCKItem *item = itemViewController.item;
    
    if ([item.name isEqualToString:@"Healing Flask"]) {
        if (self.character.currentHealth.integerValue + 4 > self.character.maximumHealth.integerValue) {
            self.character.currentHealth = self.character.maximumHealth;
        }
        else {
            self.character.currentHealth = @(self.character.currentHealth.integerValue + 4);
        }
        
        self.increaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:self.character.maximumHealth];
        self.decreaseHealthButton.enabled = YES;
        
        [self updateHealthText];
        
        [self.character removeItemFromInventory:item];
        
        LCKItem *emptyFlask = [LCKItemProvider itemForName:item.emptyItemName];
        emptyFlask.equipped = YES;
        emptyFlask.equippedSlot = item.equippedSlot;
        
        [self.character addItemToInventory:emptyFlask];
        
        [self updateItemButtons];
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    }
    
    [self dismissCurrentlyPresentedViewController:nil];
}

#pragma mark - LCKEquipmentViewControllerDelegate

- (void)itemWasSelected:(LCKItem *)item equipmentSlot:(LCKEquipmentSlot)equipmentSlot {
    item.equippedSlot = equipmentSlot;
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
