//
//  LCKMonsterViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterViewController.h"
#import "LCKMonster.h"
#import "LCKMonsterAttack.h"
#import "LCKMonsterAttribute.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

@interface LCKMonsterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *monsterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monsterImageView;
@property (weak, nonatomic) IBOutlet UIView *nameSeparatorLine;
@property (weak, nonatomic) IBOutlet UITextView *monsterTextView;

@property (nonatomic) LCKMonster *monster;

@end

@implementation LCKMonsterViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    self.monsterImageView.image = self.monster.image;
    
    self.monsterTextView.backgroundColor = [UIColor backgroundColor];
    self.monsterTextView.attributedText = [self monsterText];
    self.monsterTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.monsterTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    
    self.title = self.monster.name;
}

#pragma mark - LCKMonsterViewController

- (instancetype)initWithMonster:(LCKMonster *)monster {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MonsterViewController"];
    
    if (self) {
        _monster = monster;
    }
    
    return self;
}

- (NSAttributedString *)monsterText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

    [attributedString appendAttributedString:[self monsterHealthAttributedString]];
    
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[self monsterACAttributedString]];
    
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[self monsterToHitNumberAttributedString]];
    
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[self monsterSoulValueAttributedString]];
    
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[self monsterAttributesAttributedString]];
    
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    [attributedString appendAttributedString:[self monsterAttacksAttributedString]];
    
    return attributedString;
}

- (NSAttributedString *)monsterHealthAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"Health: "]];
    [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:self.monster.health.stringValue]];
    
    return attributedString;
}

- (NSAttributedString *)monsterACAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"AC: "]];
    [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:self.monster.AC.stringValue]];
    
    return attributedString;
}

- (NSAttributedString *)monsterToHitNumberAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"Hit Number: "]];
    [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:self.monster.hitNumber.stringValue]];
    
    return attributedString;
}

- (NSAttributedString *)monsterSoulValueAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"Soul Value: "]];
    [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:self.monster.soulValue.stringValue]];
    
    return attributedString;
}

- (NSAttributedString *)monsterAttributesAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (self.monster.attributes.count) {
        [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"Attributes"]];
        [attributedString appendAttributedString:[[self class] newlineAttributedString]];
        
        for (LCKMonsterAttribute *attribute in self.monster.attributes) {
            [attributedString appendAttributedString:[[self class] titleAttributedStringForString:attribute.name]];
            [attributedString appendAttributedString:[[self class] newlineAttributedString]];
            [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:attribute.attributeDescription]];
        }
    }
    
    return attributedString;
}

- (NSAttributedString *)monsterAttacksAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSString *attacksDice = @"1-20";
    if (self.monster.hasSignalAttacks) {
        attacksDice = @"1-10";
    }
    
    NSString *attackTitleString = [NSString stringWithFormat:@"Attacks %@", attacksDice];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:attackTitleString]];
    [attributedString appendAttributedString:[[self class] newlineAttributedString]];
    
    for (LCKMonsterAttack *attack in self.monster.attacks) {
        if (!attack.isSignalAttack) {
            [attributedString appendAttributedString:[[self class] attackAttributedStringForAttack:attack]];
        }
    }
    
    if (self.monster.hasSignalAttacks) {
        [attributedString appendAttributedString:[[self class] newlineAttributedString]];
        [attributedString appendAttributedString:[[self class] titleAttributedStringForString:@"Signal Attacks 11-20"]];
        [attributedString appendAttributedString:[[self class] newlineAttributedString]];
        
        for (LCKMonsterAttack *attack in self.monster.attacks) {
            if (attack.isSignalAttack) {
                [attributedString appendAttributedString:[[self class] attackAttributedStringForAttack:attack]];
            }
        }
    }
    
    return attributedString;
}

+ (NSAttributedString *)newlineAttributedString {
    return [[NSAttributedString alloc] initWithString:@"\n"];
}

+ (NSAttributedString *)attackAttributedStringForAttack:(LCKMonsterAttack *)attack {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

    NSString *attackTitle = [NSString stringWithFormat:@"%@  %@\n", attack.attackName, attack.diceRoll];
    NSString *attackDescription = [NSString stringWithFormat:@"%@\n", attack.attackDescription];
    
    [attributedString appendAttributedString:[[self class] titleAttributedStringForString:attackTitle]];
    [attributedString appendAttributedString:[[self class] descriptionAttributedStringForString:attackDescription]];

    return attributedString;
}

+ (NSAttributedString *)descriptionAttributedStringForString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont descriptiveTextFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor descriptiveTextColor]}];
}

+ (NSAttributedString *)titleAttributedStringForString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont titleTextFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor titleTextColor]}];
}

@end
