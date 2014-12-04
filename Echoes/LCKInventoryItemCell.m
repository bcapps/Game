//
//  LCKInventoryItemCell.m
//  Echoes
//
//  Created by Andrew Harrison on 12/4/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKInventoryItemCell.h"

@implementation LCKInventoryItemCell

#pragma mark - UIResponder

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(equipItem)) {
        return YES;
    }
        
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - LCKInventoryItemCell

- (void)equipItem {
    [self.delegate itemCellWasEquipped:self];
}

@end
