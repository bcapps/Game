//
//  LCKCharacterViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/2/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKCharacterViewController.h"
#import "UIColor+ColorStyle.h"

@interface LCKCharacterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *helmetButton;
@property (weak, nonatomic) IBOutlet UIButton *chestButton;
@property (weak, nonatomic) IBOutlet UIButton *rightHandButton;
@property (weak, nonatomic) IBOutlet UIButton *firstAccessoryButton;
@property (weak, nonatomic) IBOutlet UIButton *secondAccessoryButton;
@property (weak, nonatomic) IBOutlet UIButton *bootsButton;
@property (weak, nonatomic) IBOutlet UIButton *leftHandButton;
@property (weak, nonatomic) IBOutlet UIImageView *silhoutteImageView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *equipmentButtons;

@property (nonatomic) Character *character;

@end

@implementation LCKCharacterViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    [self setupSilhoutteGender];
    [self setupEquipmentButtons];
}

#pragma mark - LCKCharacterViewController

- (instancetype)initWithCharacter:(Character *)character {
    self = [super init];
    
    if (self) {
        _character = character;
    }
    
    return self;
}

#pragma mark - Silhoutte

- (void)setupSilhoutteGender {
    if (self.character.characterGender == CharacterGenderMale) {
        self.silhoutteImageView.image = [UIImage imageNamed:@"SilhoutteMale"];
    }
    else {
        self.silhoutteImageView.image = [UIImage imageNamed:@"SilhoutteFemale"];
    }
}

#pragma mark - Equipment Buttons

- (void)setupEquipmentButtons {
    for (UIButton *equipmentButton in self.equipmentButtons) {
        equipmentButton.layer.masksToBounds = NO;
        equipmentButton.layer.cornerRadius = 8.0;
        equipmentButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        equipmentButton.layer.borderWidth = 1.0;
        
        equipmentButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
}

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

@end
