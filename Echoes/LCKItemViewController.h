//
//  LCKItemViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

#import "LCKItem.h"

@class LCKItemViewController;

@protocol LCKItemViewControllerDelegate <NSObject>

- (void)unequipButtonTappedForItemViewController:(LCKItemViewController *)itemViewController;

@end

@interface LCKItemViewController : UIViewController

@property (nonatomic, weak) id <LCKItemViewControllerDelegate> delegate;
@property (nonatomic, readonly) LCKItem *item;

- (instancetype)initWithItem:(LCKItem *)item;

@end
