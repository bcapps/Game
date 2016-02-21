//
//  UIViewController+LCKAdditions.h
//  Velocity
//
//  Created by Brian Capps on 1/19/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LCKAdditions)

- (void)dismissAllPresentedViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)adjustScrollView:(UIScrollView *)scrollView forKeyboardChangeNotification:(NSNotification *)notification;

@end
