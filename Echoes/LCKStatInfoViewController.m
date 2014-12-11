//
//  LCKStatInfoViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/11/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKStatInfoViewController.h"
#import "UIColor+ColorStyle.h"
#import "UIFont+FontStyle.h"

@interface LCKStatInfoViewController ()

@property (nonatomic) UITextView *infoTextView;
@property (nonatomic) UIImageView *arrowImageView;

@property (nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation LCKStatInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.view.frame) - 10.0, CGRectGetHeight(self.view.frame))];
    self.infoTextView.backgroundColor = [UIColor clearColor];
    self.infoTextView.editable = NO;
    self.infoTextView.text = [CharacterStats statDescriptionForStatType:self.statType];
    self.infoTextView.textColor = [UIColor titleTextColor];
    self.infoTextView.font = [UIFont descriptiveTextFontOfSize:14.0];
    
    [self.view addSubview:self.infoTextView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), 0.0f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 10.0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) + 10.0, CGRectGetHeight(self.view.frame) - 10.0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect), CGRectGetHeight(self.view.frame));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.presentingRect) - 10.0, CGRectGetHeight(self.view.frame) - 10.0);
    CGPathAddLineToPoint(path, NULL, 0.0, CGRectGetHeight(self.view.frame) - 10.0);
    CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
    
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