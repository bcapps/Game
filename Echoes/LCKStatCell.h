//
//  LCKStatCell.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

extern NSString * const LCKStatCellReuseIdentifier;

@interface LCKStatCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *statNameLabel;
@property (nonatomic, readonly) UILabel *statValueLabel;

@end
