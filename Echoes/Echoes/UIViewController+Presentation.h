//
//  UIViewController+Presentation.h
//  Echoes
//
//  Created by Andrew Harrison on 12/30/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import UIKit;

typedef void(^UIViewControllerDismissPresentationBlock)();

@interface UIViewController (Presentation)

- (void)presentViewController:(UIViewController *)viewController currentlyPresentedViewController:(UIViewController *)currentlyPresentedViewController withFrame:(CGRect)frame fromView:(UIView *)view;
- (void)dismissCurrentlyPresentedViewController:(UIViewController *)presentedViewController animationBlock:(UIViewControllerDismissPresentationBlock)animation withCompletion:(UIViewControllerDismissPresentationBlock)completion;

@end
