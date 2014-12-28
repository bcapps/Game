//
//  LCKLoreProvider.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLoreProvider.h"
#import "LCKLoreGroup.h"

@implementation LCKLoreProvider

+ (NSArray *)loreGroups {
    static NSArray *lore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *groupArray = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Lore" ofType:@"plist"];
        
        NSDictionary *loreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        [loreDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *groupTitle, NSArray *loreArray, BOOL *stop) {
            LCKLoreGroup *loreGroup = [[LCKLoreGroup alloc] initWithDictionaryArray:loreArray title:groupTitle];
            
            [groupArray addObject:loreGroup];
        }];
        
        lore = [groupArray copy];
    });
    
    return lore;
}

@end
