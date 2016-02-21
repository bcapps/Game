//
//  LCKStatsCollectionViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/30/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

#import "CharacterStats.h"

@protocol LCKStatsCollectionViewControllerDelegate <NSObject>

- (void)statItemWasTappedForStatType:(LCKStatType)statType selectedCell:(UICollectionViewCell *)selectedCell;

@end

@class CharacterStats;

@interface LCKStatsCollectionViewController : UICollectionViewController

@property (nonatomic) CharacterStats *displayedStats;
@property (nonatomic, weak) id <LCKStatsCollectionViewControllerDelegate> delegate;

@end
