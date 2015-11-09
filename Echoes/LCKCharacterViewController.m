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
#import "LCKLevelUpTableViewController.h"

#import "LCKMultipeer+Messaging.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"
#import "UIViewController+Presentation.h"
#import "LCKStatsCollectionViewController.h"
#import "LCKItemButtonController.h"

#import <LCKCategories/NSArray+LCKAdditions.h>
#import <UICountingLabel/UICountingLabel.h>

typedef void(^LCKItemViewControllerDismissCompletion)();

const CGFloat LCKCharacterViewControllerAnimationDuration = 0.4;
const CGFloat LCKItemViewControllerHorizontalMargin = 45.0;
const CGFloat LCKItemViewControllerVerticalMargin = 100.0;

const CGFloat LCKCharacterViewControllerNumberOfStats = 5;
const CGFloat LCKCharacterViewControllerStatHeight = 50.0;
const CGFloat LCKCharacterViewControllerFemaleFix = 40.0;

const CGFloat LCKCharacterStatInfoViewHorizontalMargin = 10.0;
const CGFloat LCKCharacterStatInfoViewHeight = 145.0;
const CGFloat LCKCharacterStatInfoViewBottomMargin = 10.0;

@interface LCKCharacterViewController () <LCKItemViewControllerDelegate, LCKEquipmentViewControllerDelegate, LCKInventoryTableViewControllerDelegate, LCKLevelUpDelegate, LCKMultipeerEventListener, LCKStatsCollectionViewControllerDelegate>

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

@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UIButton *increaseHealthButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseHealthButton;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silhouetteWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silhouetteHeightConstraint;

@property (strong, nonatomic) IBOutletCollection(LCKItemButton) NSArray *equipmentButtons;

@property (nonatomic) LCKStatsCollectionViewController *statsCollectionViewController;

@property (nonatomic) UIViewController *currentlyPresentedItemViewController;
@property (nonatomic) UIView *overlayView;

@property (nonatomic) LCKMultipeer *multipeer;
@property (nonatomic) LCKItemButtonController *itemButtonController;

@end

@implementation LCKCharacterViewController

#pragma mark - NSObject

- (void)dealloc {
    [self.multipeer stopMultipeerConnectivity];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    self.title = self.character.name;
    
    [self setupSilhouetteGender];
    self.healthLabel.font = [UIFont titleTextFontOfSize:15.0];
    
    [self updateHealthStatus];
    
    self.healthImageView.image = [self.healthImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.multipeer = [[LCKMultipeer alloc] initWithMultipeerUserType:LCKMultipeerUserTypeClient peerName:self.character.displayName serviceName:@"echoes"];
    [self.multipeer addEventListener:self];
    [self.multipeer startMultipeerConnectivity];
    
    self.silhouetteHeightConstraint.constant = CGRectGetHeight(self.view.frame) * 0.65;
    self.silhouetteWidthConstraint.constant = self.silhouetteHeightConstraint.constant * (self.silhouetteImageView.image.size.width / self.silhouetteImageView.image.size.height);
    
    if (self.character.characterGender == CharacterGenderFemale) {
        self.silhouetteWidthConstraint.constant -= LCKCharacterViewControllerFemaleFix;
    }
    
    self.itemButtonController = [[LCKItemButtonController alloc] init];
    
    [self.view updateConstraintsIfNeeded];
        
    [self setItemSlotsForItemButtons];
    
    [self.soulsButton setImage:[UIImage imageNamed:@"soulsIcon"] forState:UIControlStateNormal];
    self.soulsButton.soulLabel.method = UILabelCountingMethodLinear;
    self.soulsButton.soulLabel.format = @"%d";
    [self.soulsButton.soulLabel countFromCurrentValueTo:self.character.souls.floatValue withDuration:0.0];
    
    [self.soulsButton addTarget:self action:@selector(didSelectSoulsButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.overlayView.hidden = YES;
    [self.view addSubview:self.overlayView];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.itemButtonController updateItemButtonsForCharacter:self.character];
}

- (void)setItemSlotsForItemButtons {
    self.itemButtonController.leftHandButton = self.leftHandButton;
    self.itemButtonController.rightHandButton = self.rightHandButton;
    
    self.itemButtonController.helmetButton = self.helmetButton;
    self.itemButtonController.chestButton = self.chestButton;
    self.itemButtonController.bootsButton = self.bootsButton;
    
    self.itemButtonController.firstAccessoryButton = self.firstAccessoryButton;
    self.itemButtonController.secondAccessoryButton = self.secondAccessoryButton;
    
    self.itemButtonController.firstSpellButton = self.firstSpellButton;
    self.itemButtonController.secondSpellButton = self.secondSpellButton;
    self.itemButtonController.thirdSpellButton = self.thirdSpellButton;
    self.itemButtonController.fourthSpellButton = self.fourthSpellButton;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInventoryViewController"]) {
        LCKInventoryTableViewController *inventoryViewController = segue.destinationViewController;
        inventoryViewController.delegate = self;
        inventoryViewController.multipeer = self.multipeer;
        
        inventoryViewController.character = self.character;
    }
    else if ([segue.identifier isEqualToString:@"StatsViewControllerEmbed"]) {
        self.statsCollectionViewController = segue.destinationViewController;
        
        self.statsCollectionViewController.displayedStats = self.character.characterStats;
        self.statsCollectionViewController.delegate = self;
    }
}

#pragma mark - LCKCharacterViewController

- (void)updateHealthStatus {
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
    
    self.increaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:self.character.maximumHealth];
    self.decreaseHealthButton.enabled = ![self.character.currentHealth isEqualToNumber:@(0)];
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentlyPresentedViewController)];
        
        [_overlayView addGestureRecognizer:dismissGesture];
    }
    
    return _overlayView;
}

- (CGRect)itemControllerFrame {
    return CGRectMake(LCKItemViewControllerHorizontalMargin, LCKItemViewControllerVerticalMargin, CGRectGetWidth(self.view.frame) - LCKItemViewControllerHorizontalMargin * 2, CGRectGetHeight(self.view.frame) - LCKItemViewControllerVerticalMargin * 2);
}

- (CGRect)levelUpControllerFrame {
    return CGRectMake(LCKItemViewControllerHorizontalMargin, LCKItemViewControllerVerticalMargin, CGRectGetWidth(self.view.frame) - LCKItemViewControllerHorizontalMargin * 2, 280.0);
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

- (void)presentViewController:(UIViewController *)viewController withFrame:(CGRect)frame fromView:(UIView *)view {
    if (!viewController) {
        return;
    }
    
    self.overlayView.hidden = NO;
    self.overlayView.alpha = 1.0;

    [self presentViewController:viewController currentlyPresentedViewController:self.currentlyPresentedItemViewController withFrame:frame fromView:view];
    self.currentlyPresentedItemViewController = viewController;
}

- (void)dismissCurrentlyPresentedViewController {
    [self dismissCurrentlyPresentedViewController:self.currentlyPresentedItemViewController animationBlock:^{
        self.overlayView.alpha = 0.0;
    } withCompletion:^{
        self.currentlyPresentedItemViewController = nil;
        
        self.overlayView.hidden = YES;
        self.overlayView.alpha = 1.0;
    }];
}

- (void)didSelectSoulsButton {
    LCKInfoViewController *infoViewController = [self newInfoViewController];
    infoViewController.presentingRect = self.soulsButton.frame;
    infoViewController.arrowDirection = UIPopoverArrowDirectionUp;
    
    [self presentViewController:infoViewController withFrame:[self infoViewFrameForStatusFrame:self.soulsButton.frame] fromView:self.soulsButton];

    NSString *soulsText = [NSString stringWithFormat:@"· Souls are gained by defeating powerful enemies and absorbing their souls.\n· Souls can be used to level up (%@).\n· Souls can be used to purchase items.", [self.character soulValueForLevelUp].stringValue];
    
    infoViewController.infoTextView.text = soulsText;
}

- (IBAction)equipmentButtonTapped:(LCKItemButton *)button {
    UIViewController *viewController;
    
    if (button.item) {
        viewController = [self newItemViewControllerForItem:button.item];
    }
    else {
        NSArray *equipmentTypes = [self.itemButtonController equipmentTypesForItemButton:button];
        LCKEquipmentSlot equipmentSlot = [self.itemButtonController equipmentSlotForItemButton:button];
        
        viewController = [self newEquipmentViewControllerForEquipmentTypes:equipmentTypes equipmentSlot:equipmentSlot];        
    }
    
    [self presentViewController:viewController withFrame:[self itemControllerFrame] fromView:button];
}

- (IBAction)increaseHealthButtonTapped:(UIButton *)sender {
    [self modifyCurrentCharacterHealthBy:1];
}

- (IBAction)decreaseHealthButtonTapped:(UIButton *)sender {
    [self modifyCurrentCharacterHealthBy:-1];
}

- (void)modifyCurrentCharacterHealthBy:(NSInteger)healthModificationValue {
    NSInteger newHealth = self.character.currentHealth.integerValue + healthModificationValue;
    
    if (newHealth > self.character.maximumHealth.integerValue) {
        newHealth = self.character.maximumHealth.integerValue;
    }
    else if (newHealth < 0) {
        newHealth = 0;
    }
    
    self.character.currentHealth = @(newHealth);
    [self updateHealthStatus];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

#pragma mark - Multipeer

- (void)itemReceived:(NSString *)itemName {
    LCKItem *item = [LCKItemProvider itemForName:itemName];
    
    [self.character addItemToInventory:item];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    LCKItemViewController *itemViewController = [self newItemViewControllerForItem:item];
    
    [self presentViewController:itemViewController withFrame:[self itemControllerFrame] fromView:nil];
}

- (void)soulsReceived:(NSNumber *)souls {
    NSNumber *newAmount = @(self.character.souls.integerValue + souls.integerValue);
    
    [self.soulsButton.soulLabel countFromCurrentValueTo:newAmount.floatValue withDuration:1.5];
    
    self.character.souls = newAmount;
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
}

- (void)eventReceived:(NSString *)eventName {
    if ([eventName isEqualToString:LCKEventProviderRestAtBonfireEventName]) {
        LCKItem *emptyFlask;
        
        for (LCKItem *item in self.character.items) {
            if ([item.name isEqualToString:@"Empty Flask"]) {
                emptyFlask = item;
                break;
            }
        }
        
        self.character.currentHealth = self.character.maximumHealth;
        
        if (emptyFlask) {
            LCKItem *healingFlask = [LCKItemProvider itemForName:@"Healing Flask"];
            healingFlask.equipped = emptyFlask.equipped;
            healingFlask.equippedSlot = emptyFlask.equippedSlot;
            
            [self.character removeItemFromInventory:emptyFlask];
            [self.character addItemToInventory:healingFlask];

            [self.itemButtonController updateItemButtonsForCharacter:self.character];
        }
        
        [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
        [self updateHealthStatus];
    }
    else if ([eventName isEqualToString:LCKEventProviderLevelUpEventName] && self.character.canLevelUp) {
        LCKLevelUpTableViewController *levelUpController = [[LCKLevelUpTableViewController alloc] initWithCharacter:self.character];
        levelUpController.delegate = self;
        [self presentViewController:levelUpController withFrame:[self levelUpControllerFrame] fromView:nil];
    }
}

#pragma mark - LCKStatsCollectionViewControllerDelegate

- (void)statItemWasTappedForStatType:(LCKStatType)statType selectedCell:(UICollectionViewCell *)selectedCell {
    UICollectionView *collectionView = self.statsCollectionViewController.collectionView;
    
    LCKInfoViewController *infoViewController = [self newInfoViewController];
    infoViewController.arrowDirection = UIPopoverArrowDirectionDown;
    
    CGRect cellFrame = [self.view convertRect:selectedCell.frame fromView:collectionView];
    
    CGRect presentationFrame = [self statInfoViewFrameForCellFrame:cellFrame];
    
    infoViewController.presentingRect = CGRectMake(cellFrame.origin.x - LCKCharacterStatInfoViewHorizontalMargin, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.width);
    
    [self presentViewController:infoViewController withFrame:presentationFrame fromView:selectedCell];
    
    infoViewController.titleLabel.text = [CharacterStats statTitleForStatType:statType];
    infoViewController.infoTextView.text = [CharacterStats statDescriptionForStatType:statType];
}

#pragma mark - LCKItemViewControllerDelegate

- (void)unequipButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    [self.character unequipItem:itemViewController.item];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self.itemButtonController updateItemButtonsForCharacter:self.character];
    [self dismissCurrentlyPresentedViewController];
}

- (void)useItemButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    LCKItem *item = itemViewController.item;
    
    if ([item.name isEqualToString:@"Healing Flask"]) {
        [self modifyCurrentCharacterHealthBy:4];
        
        [self updateHealthStatus];
        
        [self.character removeItemFromInventory:item];
        
        LCKItem *emptyFlask = [LCKItemProvider itemForName:item.emptyItemName];
        emptyFlask.equipped = YES;
        emptyFlask.equippedSlot = item.equippedSlot;
        
        [self.character addItemToInventory:emptyFlask];
    }
    else if ([item.name isEqualToString:@"Firebomb"]) {
        [self.character removeItemFromInventory:item];
    }
    
    [self.itemButtonController updateItemButtonsForCharacter:self.character];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self dismissCurrentlyPresentedViewController];
}

- (void)closeButtonTappedForItemViewController:(LCKItemViewController *)itemViewController {
    [self dismissCurrentlyPresentedViewController];
}

#pragma mark - LCKEquipmentViewControllerDelegate

- (void)itemWasSelected:(LCKItem *)item equipmentSlot:(LCKEquipmentSlot)equipmentSlot {
    item.equippedSlot = equipmentSlot;
    [self.character equipItem:item];
    
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];
    
    [self.itemButtonController updateItemButtonsForCharacter:self.character];
    [self dismissCurrentlyPresentedViewController];
}

- (void)closeButtonWasTappedForEquipmentViewController:(LCKEquipmentViewController *)viewController {
    [self dismissCurrentlyPresentedViewController];
}

#pragma mark - LCKInventoryTableViewControllerDelegate

- (void)itemWasGiftedFromInventory:(LCKItem *)item {
    [self.navigationController popToViewController:self animated:YES];
    
    [self.character removeItemFromInventory:item];
}

#pragma mark - LCKLevelUpDelegate

- (void)levelUpButtonTappedForController:(LCKLevelUpTableViewController *)controller statTypeToLevel:(LCKStatType)statType {
    [self.character.characterStats addStatValue:1 forStatType:statType];
    [self.character increaseLevel];
    [[LCKEchoCoreDataController sharedController] saveContext:self.character.managedObjectContext];

    [self updateHealthStatus];
    
    self.statsCollectionViewController.displayedStats = self.character.characterStats;
    [self.statsCollectionViewController.collectionView reloadData];
    [self.soulsButton.soulLabel countFromCurrentValueTo:self.character.souls.floatValue withDuration:1.5];
    
    [self dismissCurrentlyPresentedViewController];
}

#pragma mark - LCKMultipeerEventListener

- (void)multipeer:(LCKMultipeer *)multipeer receivedMessage:(LCKMultipeerMessage *)message fromPeer:(MCPeerID *)peer {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:message.data options:0 error:nil];
    id value = [dictionary objectForKey:LCKMultipeerValueKey];
    
    if (message.type == LCKMultipeerManagerSendTypeItem) {
        [self itemReceived:value];
    }
    else if (message.type == LCKMultipeerManagerSendTypeSouls) {
        [self soulsReceived:value];
    }
    else if (message.type == LCKMultipeerManagerSendTypeEvent) {
        [self eventReceived:value];
    }
}

@end
