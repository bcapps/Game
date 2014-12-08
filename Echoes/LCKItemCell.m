//
//  LCKItemCell.m
//  Echoes
//
//  Created by Andrew Harrison on 12/7/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItemCell.h"

#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

@implementation LCKItemCell

#pragma mark - NSObject+UINibLoadingAdditions

- (void)awakeFromNib {
    [self commonInitialization];
}

#pragma mark - UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

#pragma mark - LCKItemCell

- (void)commonInitialization {
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.textLabel.font = [UIFont titleTextFontOfSize:14.0];
    self.textLabel.textColor = [UIColor titleTextColor];
}

@end
