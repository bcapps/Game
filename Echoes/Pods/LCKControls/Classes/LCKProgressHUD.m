//
//  LCKProgressHUD.m
//  Velocity
//
//  Created by Andrew Harrison on 7/7/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "LCKProgressHUD.h"

static const CGFloat LCKProgressHUDDisplayDuration = 1.7;

@interface SVProgressHUD ()

@property (nonatomic, strong) UIView *hudView;

@end

@implementation LCKProgressHUD

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return LCKProgressHUDDisplayDuration;
}

- (UIView *)hudView {
    UIView *hudView = [super hudView];
    if (![hudView.motionEffects count]) {
        [self setupMotionEffectsOnHudView];
    }
    
    return hudView;
}

- (void)setupMotionEffectsOnHudView {
    CGFloat maximumXRelativeValue = 15;
    CGFloat maximumYRelativeValue = 15;
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-maximumXRelativeValue);
    horizontalMotionEffect.maximumRelativeValue = @(maximumXRelativeValue);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-maximumYRelativeValue);
    verticalMotionEffect.maximumRelativeValue = @(maximumYRelativeValue);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [[super hudView] addMotionEffect:motionEffectGroup];
}

@end
