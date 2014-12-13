//
//  LCKItemViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItemViewController.h"
#import "Character.h"
#import "CharacterStats.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKItemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemFlavorTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRequirementsLabel;
@property (weak, nonatomic) IBOutlet UIButton *unequipButton;
@property (weak, nonatomic) IBOutlet UIView *nameSeparatorLineView;
@property (weak, nonatomic) IBOutlet UIImageView *itemTypeImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;

@property (nonatomic) LCKItem *item;
@property (nonatomic) LCKItemViewControllerDisplayStyle displayStyle;

@end

@implementation LCKItemViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNameLabel.text = self.item.name;
    self.itemNameLabel.textColor = [UIColor titleTextColor];
    self.itemNameLabel.font = [UIFont titleTextFontOfSize:16.0];
    
    self.itemImageView.image = [UIImage imageNamed:self.item.imageName];
    
    NSMutableAttributedString *attributedAction = [[NSMutableAttributedString alloc] init];
    NSArray *actionComponents = [self.item.actionText componentsSeparatedByString:@":"];
    
    if (((NSString *)[actionComponents firstObject]).length) {
        NSAttributedString *action = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", actionComponents.firstObject] attributes:@{NSFontAttributeName: [UIFont boldTitleTextFontOfSize:15.0], NSForegroundColorAttributeName: [UIColor titleTextColor]}];
        
        [attributedAction appendAttributedString:action];
    }
    
    if ([actionComponents safeObjectAtIndex:1]) {
        NSAttributedString *actionText = [[NSAttributedString alloc] initWithString:[actionComponents safeObjectAtIndex:1] attributes:@{NSFontAttributeName: [UIFont descriptiveTextFontOfSize:15.0], NSForegroundColorAttributeName: [UIColor titleTextColor]}];
        
        [attributedAction appendAttributedString:actionText];
    }
    
    self.itemActionLabel.attributedText = attributedAction;
    
    self.itemDescriptionLabel.text = self.item.descriptionText;
    self.itemDescriptionLabel.textColor = [UIColor descriptiveTextColor];
    self.itemDescriptionLabel.font = [UIFont descriptiveTextFontOfSize:14.0];
    
    self.itemFlavorTextLabel.text = self.item.flavorText;
    self.itemFlavorTextLabel.textColor = [UIColor flavorTextColor];
    self.itemFlavorTextLabel.font = [UIFont italicDescriptiveTextFontOfSize:14.0];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    for (NSString *requirement in self.item.attributeRequirements) {
        NSAttributedString *attributedRequirement;
        
        if ([attributedText length]) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@", " attributes:@{NSFontAttributeName: [UIFont descriptiveTextFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor descriptiveTextColor]}]];
        }
        
        if (![self.character meetsRequirement:requirement forItem:self.item]) {
            attributedRequirement = [[NSAttributedString alloc] initWithString:requirement attributes:@{NSFontAttributeName: [UIFont descriptiveTextFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor removeColor]}];
        }
        else {
            attributedRequirement = [[NSAttributedString alloc] initWithString:requirement attributes:@{NSFontAttributeName: [UIFont descriptiveTextFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor descriptiveTextColor]}];
        }
        
        [attributedText appendAttributedString:attributedRequirement];
    }
    
    self.itemRequirementsLabel.attributedText = attributedText;
    
    self.itemTypeImageView.image = [[LCKItem imageForItemSlot:self.item.itemSlot] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.unequipButton.titleLabel.font = [UIFont descriptiveTextFontOfSize:14.0];
    [self.unequipButton setTitleColor:[UIColor removeColor] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    if (self.displayStyle == LCKItemViewControllerDisplayStylePopup) {
        self.view.layer.masksToBounds = NO;
        self.view.layer.cornerRadius = 8.0;
        self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.borderWidth = 1.0;
    }
    else {
        self.title = self.item.name;
        self.itemNameLabel.hidden = YES;
        self.nameSeparatorLineView.hidden = YES;
        
        UIBarButtonItem *giftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"giftIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(giftItem)];
        
        self.navigationItem.rightBarButtonItem = giftButton;
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.unequipButton.hidden = !self.item.isEquipped;
}

#pragma mark - LCKItemViewController

- (instancetype)initWithItem:(LCKItem *)item displayStyle:(LCKItemViewControllerDisplayStyle)displayStyle {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItemViewController"];
    
    if (self) {
        _item = item;
        _displayStyle = displayStyle;
    }
    
    return self;
}

- (IBAction)unequipButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(unequipButtonTappedForItemViewController:)]) {
        [self.delegate unequipButtonTappedForItemViewController:self];
    }
}

- (void)giftItem {
    if ([self.delegate respondsToSelector:@selector(giftItemButtonTappedForItemViewController:)]) {
        [self.delegate giftItemButtonTappedForItemViewController:self];
    }
}

@end
