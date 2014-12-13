//
//  LCKSoulGiftingViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/13/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKSoulGiftingViewController.h"
#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"
#import "LCKAllPeersViewController.h"

@interface LCKSoulGiftingViewController ()

@property (nonatomic) UITextField *textField;

@end

@implementation LCKSoulGiftingViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 80.0, CGRectGetWidth(self.view.frame) - 80.0, 44.0)];
    self.textField.font = [UIFont titleTextFontOfSize:15.0];
    self.textField.textColor = [UIColor titleTextColor];
    self.textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.textField.layer.borderWidth = 1.0;
    self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
    
    UIBarButtonItem *giftButton = [[UIBarButtonItem alloc] initWithTitle:@"Gift" style:UIBarButtonItemStyleDone target:self action:@selector(giftSouls)];
    
    self.navigationItem.rightBarButtonItem = giftButton;
}

#pragma mark - LCKSoulGiftingViewController

- (void)giftSouls {
    LCKAllPeersViewController *peersViewController = [[LCKAllPeersViewController alloc] initWithMultipeerManager:self.multipeerManager];
    peersViewController.soulsToGive = @([self.textField.text integerValue]);
    [self.navigationController pushViewController:peersViewController animated:YES];
}

@end
