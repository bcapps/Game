//
//  LCKLoreProvider.m
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLoreProvider.h"
#import "LCKLore.h"

@implementation LCKLoreProvider

+ (NSArray *)allLore {
    static NSArray *lore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *loreArray = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Lore" ofType:@"plist"];
        
        NSDictionary *loreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        [loreDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *loreTitle, NSString *loreDescription, BOOL *stop) {
            LCKLore *lore = [[LCKLore alloc] initWithTitle:loreTitle lore:loreDescription];
            
            [loreArray addObject:lore];
        }];
        
        lore = [loreArray copy];
    });
    
    return lore;
}

@end
