//
//  LCKInfoViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/12/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKInfoViewController.h"
#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

@interface LCKInfoViewController ()

@property (nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation LCKInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    
    self.infoTextView = [[UITextView alloc] init];
    self.infoTextView.backgroundColor = [UIColor clearColor];
    self.infoTextView.editable = NO;
    self.infoTextView.textColor = [UIColor titleTextColor];
    self.infoTextView.font = [UIFont descriptiveTextFontOfSize:14.0];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor titleTextColor];
    self.titleLabel.font = [UIFont titleTextFontOfSize:14.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.infoTextView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat infoTextStartingY = 0.0;
    if (self.titleLabel.text.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.frame), CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(0, CGRectGetMinY(self.infoTextView.frame) - 10.0, CGRectGetWidth(self.view.frame), size.height);

        infoTextStartingY = CGRectGetMaxY(self.titleLabel.frame) + 3.0;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        self.infoTextView.frame = CGRectMake(5, infoTextStartingY, CGRectGetWidth(self.view.frame) - 10.0, CGRectGetHeight(self.view.frame));
        CGPathMoveToPoint(path,NULL, 0.0, infoTextStartingY);

        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), infoTextStartingY);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 10.0);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) + 10.0, CGRectGetHeight(self.view.frame) - 10.0);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect), CGRectGetHeight(self.view.frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) - 10.0, CGRectGetHeight(self.view.frame) - 10.0);
        
        CGPathAddLineToPoint(path, NULL, 0.0, CGRectGetHeight(self.view.frame) - 10.0);
        CGPathAddLineToPoint(path, NULL, 0.0f, infoTextStartingY);
    }
    
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        infoTextStartingY += 10.0;
        
        self.infoTextView.frame = CGRectMake(5, infoTextStartingY, CGRectGetWidth(self.view.frame) - 10.0, CGRectGetHeight(self.view.frame));
        CGPathMoveToPoint(path,NULL, 0.0, infoTextStartingY);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) - 10.0, infoTextStartingY);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect), 0.0);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) + 10.0, infoTextStartingY);
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), infoTextStartingY);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
        CGPathAddLineToPoint(path, NULL, 0.0, CGRectGetHeight(self.view.frame));
        CGPathAddLineToPoint(path, NULL, 0.0f, infoTextStartingY);
    }
    
    [self.shapeLayer removeFromSuperlayer];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.cornerRadius = 8.0;
    [self.shapeLayer setPath:path];
    [self.shapeLayer setStrokeColor:[[UIColor darkGrayColor] CGColor]];
    [self.shapeLayer setBounds:self.view.bounds];
    [self.shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [self.shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [[[self view] layer] insertSublayer:self.shapeLayer atIndex:0];
}

@end
