//
//  LCKItemViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItemViewController.h"

#import "UIFont+FontStyle.h"
#import "UIColor+ColorStyle.h"

@interface LCKItemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemFlavorTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRequirementsLabel;

@property (nonatomic) LCKItem *item;

@end

@implementation LCKItemViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNameLabel.text = self.item.name;
    self.itemNameLabel.textColor = [UIColor titleTextColor];
    self.itemNameLabel.font = [UIFont titleTextFontOfSize:14.0];
    
    self.itemImageView.image = [UIImage imageNamed:self.item.imageName];
    
    self.itemActionLabel.text = self.item.actionText;
    self.itemActionLabel.textColor = [UIColor titleTextColor];
    self.itemActionLabel.font = [UIFont descriptiveTextFontOfSize:14.0];
    
    self.itemDescriptionLabel.text = self.item.descriptionText;
    self.itemDescriptionLabel.textColor = [UIColor descriptiveTextColor];
    self.itemDescriptionLabel.font = [UIFont descriptiveTextFontOfSize:12.0];
    
    self.itemFlavorTextLabel.text = self.item.flavorText;
    self.itemFlavorTextLabel.textColor = [UIColor descriptiveTextColor];
    self.itemFlavorTextLabel.font = [UIFont italicDescriptiveTextFontOfSize:12.0];

    self.view.backgroundColor = [UIColor backgroundColor];
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = 8.0;
    // Do any additional setup after loading the view.
}

#pragma mark - LCKItemViewController

- (instancetype)initWithItem:(LCKItem *)item {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ItemViewController"];
    
    if (self) {
        _item = item;
    }
    
    return self;
}

@end