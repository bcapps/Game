//
//  LCKItemViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

#import "LCKItem.h"

@class Character;

typedef NS_ENUM(NSUInteger, LCKItemViewControllerDisplayStyle) {
    LCKItemViewControllerDisplayStyleInventory,
    LCKItemViewControllerDisplayStylePopup
};

@class LCKItemViewController;

@protocol LCKItemViewControllerDelegate <NSObject>

@optional
- (void)unequipButtonTappedForItemViewController:(LCKItemViewController *)itemViewController;
- (void)giftItemButtonTappedForItemViewController:(LCKItemViewController *)itemViewController;

@end

@interface LCKItemViewController : UIViewController

@property (nonatomic, weak) id <LCKItemViewControllerDelegate> delegate;
@property (nonatomic, readonly) LCKItem *item;

@property (nonatomic) BOOL displayInventoryOptions;
@property (nonatomic) Character *character;

- (instancetype)initWithItem:(LCKItem *)item displayStyle:(LCKItemViewControllerDisplayStyle)displayStyle;

@end
