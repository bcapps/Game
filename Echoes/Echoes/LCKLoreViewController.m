//
//  LCKLoreViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLoreViewController.h"
#import "LCKLore.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

@interface LCKLoreViewController ()

@property (nonatomic) LCKLore *lore;
@property (nonatomic) UITextView *loreTextView;

@end

@implementation LCKLoreViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:self.loreTextView];
    
    self.title = self.lore.title;
}

#pragma mark - LCKLoreViewController

- (instancetype)initWithLore:(LCKLore *)lore {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _lore = lore;
    }
    
    return self;
}

- (UITextView *)loreTextView {
    if (!_loreTextView) {
        _loreTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _loreTextView.backgroundColor = [UIColor backgroundColor];
        _loreTextView.text = self.lore.lore;
        _loreTextView.font = [UIFont descriptiveTextFontOfSize:16.0];
        _loreTextView.textColor = [UIColor titleTextColor];
        _loreTextView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    
    return _loreTextView;
}

@end
