//
//  UIAlertView+LCKAdditions.m
//  Pods
//
//  Created by Matthew Bischoff on 5/30/14.
//
//

#import "UIAlertView+LCKAdditions.h"

@implementation UIAlertView (LCKAdditions)

- (UITextField *)usernameTextField {
    if (self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
        return [self textFieldAtIndex:0];
    }
    return nil;
}

- (UITextField *)passwordTextField {
    if (self.alertViewStyle == UIAlertViewStyleSecureTextInput) {
        return [self textFieldAtIndex:0];
    }
    else if (self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
        return [self textFieldAtIndex:1];
    }
    return nil;
}


@end
