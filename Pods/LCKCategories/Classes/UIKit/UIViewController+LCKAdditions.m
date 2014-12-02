//
//  UIViewController+LCKAdditions.m
//  Velocity
//
//  Created by Brian Capps on 1/19/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UIViewController+LCKAdditions.h"

@implementation UIViewController (LCKAdditions)

- (void)dismissAllPresentedViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion {
    // Recursion until we get to the last view controller that has only one presented viewController.
    if (self.presentedViewController.presentedViewController) {
        [self.presentedViewController.presentedViewController dismissAllPresentedViewControllersAnimated:animated completion:NULL];
    }
    
    // Every iteration will dismiss their view controller, but only the first iteration (last view controller) get the completion block.
    if (self.presentedViewController){
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

- (void)adjustScrollView:(UIScrollView *)scrollView forKeyboardChangeNotification:(NSNotification *)notification {
    NSDictionary *keyboardInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect convertedFrame = [scrollView.superview convertRect:keyboardFrame fromView:scrollView.window];
    CGFloat keyboardHeight = CGRectGetHeight(convertedFrame);
    
    UIEdgeInsets contentInsets = scrollView.contentInset;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        contentInsets.bottom = keyboardHeight;
    }
    else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        contentInsets.bottom = self.bottomLayoutGuide.length;
    }
    
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end
