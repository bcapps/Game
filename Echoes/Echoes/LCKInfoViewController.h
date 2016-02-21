//
//  LCKInfoViewController.h
//  Echoes
//
//  Created by Andrew Harrison on 12/12/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCKInfoViewController : UIViewController

@property (nonatomic) CGRect presentingRect;
@property (nonatomic) UIPopoverArrowDirection arrowDirection;
@property (nonatomic) UITextView *infoTextView;
@property (nonatomic) UILabel *titleLabel;

@end
