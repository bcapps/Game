//
//  LCKStatsCollectionViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/30/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKStatsCollectionViewController.h"
#import "LCKStatCell.h"

NSUInteger const LCKStatsCollectionViewNumberOfItems = 5;

@interface LCKStatsCollectionViewController ()

@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) NSNumber *dexterity;
@property (nonatomic) NSNumber *faith;
@property (nonatomic) NSNumber *intelligence;
@property (nonatomic) NSNumber *strength;
@property (nonatomic) NSNumber *vitality;

@end

@implementation LCKStatsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[LCKStatCell class] forCellWithReuseIdentifier:LCKStatCellReuseIdentifier];    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat itemSpacing = self.flowLayout.minimumInteritemSpacing;
    CGFloat numberOfItems = LCKStatsCollectionViewNumberOfItems;
    
    self.flowLayout.itemSize = CGSizeMake((CGRectGetWidth(self.collectionView.frame) - (itemSpacing * numberOfItems)) / numberOfItems, CGRectGetHeight(self.collectionView.frame));
}

- (UICollectionViewFlowLayout *)flowLayout {
    return (UICollectionViewFlowLayout *)self.collectionViewLayout;
}

- (void)setDisplayedStats:(CharacterStats *)displayedStats {
    if (![_displayedStats isEqual:displayedStats]) {
        _vitality = displayedStats.vitality;
        _strength = displayedStats.strength;
        _intelligence = displayedStats.intelligence;
        _faith = displayedStats.faith;
        _dexterity = displayedStats.dexterity;
        
        [self.collectionView reloadData];
    }
}

- (NSString *)displayedStatStringForStatType:(LCKStatType)statType {
    switch (statType) {
        case LCKStatTypeVitality:
            return self.vitality.stringValue;
        case LCKStatTypeDexterity:
            return self.dexterity.stringValue;
        case LCKStatTypeFaith:
            return self.faith.stringValue;
        case LCKStatTypeIntelligence:
            return self.intelligence.stringValue;
        case LCKStatTypeStrength:
            return self.strength.stringValue;
    }
    
    return @"";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return LCKStatsCollectionViewNumberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCKStatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LCKStatCellReuseIdentifier forIndexPath:indexPath];

    cell.statNameLabel.text = [CharacterStats statNameForStatType:(LCKStatType)indexPath.row];
    cell.statValueLabel.text = [self displayedStatStringForStatType:(LCKStatType)indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [self.delegate statItemWasTappedForStatType:indexPath.row selectedCell:cell];
}

@end
