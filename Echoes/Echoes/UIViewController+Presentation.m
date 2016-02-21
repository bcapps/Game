//
//  UIViewController+Presentation.m
//  Echoes
//
//  Created by Andrew Harrison on 12/30/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "UIViewController+Presentation.h"

const CGFloat UIViewControllerPresentationAnimationDuration = 0.4;

@implementation UIViewController (Presentation)

- (void)presentViewController:(UIViewController *)viewController currentlyPresentedViewController:(UIViewController *)currentlyPresentedViewController withFrame:(CGRect)frame fromView:(UIView *)view {
    if (!viewController) {
        return;
    }
    
    [self dismissCurrentlyPresentedViewController:currentlyPresentedViewController animationBlock:nil withCompletion:^{
        viewController.view.frame = frame;
        viewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        [UIView animateWithDuration:UIViewControllerPresentationAnimationDuration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        
        self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    }];
}

- (void)dismissCurrentlyPresentedViewController:(UIViewController *)presentedViewController animationBlock:(UIViewControllerDismissPresentationBlock)animation withCompletion:(UIViewControllerDismissPresentationBlock)completion {
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    self.navigationController.navigationBar.tintColor = self.view.window.tintColor;
    
    if (!presentedViewController) {
        if (completion) {
            completion();
        }
    }
    else {
        [UIView animateWithDuration:UIViewControllerPresentationAnimationDuration delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            presentedViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
            
            if (animation) {
                animation();
            }
        } completion:^(BOOL finished) {
            [presentedViewController willMoveToParentViewController:nil];
            [presentedViewController.view removeFromSuperview];
            [presentedViewController removeFromParentViewController];
            
            if (completion) {
                completion();
            }
        }];
    }
}

@end
