//
//  LCKLevelUpTableViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 1/8/15.
//  Copyright (c) 2015 Lickability. All rights reserved.
//

@import UIKit;

@class Character;
@class LCKLevelUpTableViewController;

@protocol LCKLevelUpDelegate <NSObject>

- (void)levelUpButtonTappedForController:(LCKLevelUpTableViewController *)controller;

@end

@interface LCKLevelUpTableViewController : UITableViewController

- (instancetype)initWithCharacter:(Character *)character;

@property (nonatomic, weak) id <LCKLevelUpDelegate> delegate;

@end
