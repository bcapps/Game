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

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

typedef NS_ENUM(NSUInteger, LCKStatType) {
    LCKStatTypeVitality,
    LCKStatTypeStrength,
    LCKStatTypeDexterity,
    LCKStatTypeIntelligence,
    LCKStatTypeFaith
};

@interface LCKCharacterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *helmetButton;
@property (weak, nonatomic) IBOutlet UIButton *chestButton;
@property (weak, nonatomic) IBOutlet UIButton *rightHandButton;
@property (weak, nonatomic) IBOutlet UIButton *firstAccessoryButton;
@property (weak, nonatomic) IBOutlet UIButton *secondAccessoryButton;
@property (weak, nonatomic) IBOutlet UIButton *bootsButton;
@property (weak, nonatomic) IBOutlet UIButton *leftHandButton;
@property (weak, nonatomic) IBOutlet UIImageView *silhouetteImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *healthImageView;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *equipmentButtons;

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
    self.healthLabel.text = [NSString stringWithFormat:@"%@/%@", self.character.currentHealth, self.character.maximumHealth];
    
    self.healthImageView.image = [self.healthImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.collectionView registerClass:[LCKStatCell class] forCellWithReuseIdentifier:LCKStatCellReuseIdentifier];
}

#pragma mark - LCKCharacterViewController

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

- (IBAction)leftHandButtonTapped:(UIButton *)sender {
    
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
    
}
- (IBAction)decreaseHealthButtonTapped:(UIButton *)sender {
    
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
