//
//  LCKItemProvider.h
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCKItem;

@interface LCKItemProvider : NSObject

+ (NSArray *)allItems;

+ (LCKItem *)itemForName:(NSString *)itemName;

@end
