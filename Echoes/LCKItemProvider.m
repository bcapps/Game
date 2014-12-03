//
//  LCKItemProvider.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItemProvider.h"
#import "LCKItem.h"

@interface LCKItemProvider ()

@end

@implementation LCKItemProvider

+ (NSArray *)allItems {
    static NSArray *items;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableArray *itemArray = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
        
        for (NSDictionary *itemDictionary in [NSArray arrayWithContentsOfFile:filePath]) {
            LCKItem *item = [[LCKItem alloc] initWithDictionary:itemDictionary];
            
            [itemArray addObject:item];
        }
        
        items = [itemArray copy];
    });
    
    return items;
}

@end
