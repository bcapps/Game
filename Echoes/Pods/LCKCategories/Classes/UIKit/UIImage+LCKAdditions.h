//
//  UIImage+LCKAdditions.h
//  Velocity
//
//  Created by Brian Capps on 1/6/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LCKAdditions)

+ (UIImage *)templateImageNamed:(NSString *)imageName;
- (UIImage *)templateImage;

+ (UIImage *)imageFromColor:(UIColor *)color;

@end
