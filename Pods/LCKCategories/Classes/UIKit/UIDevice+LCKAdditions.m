//
//  UIDevice+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//
//

#import "UIDevice+LCKAdditions.h"

@implementation UIDevice (LCKAdditions)

+ (BOOL)isiPhone {
    return [[self currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isiPad {
    return [[self currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
