//
//  LCKMonsterProvider.m
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMonsterProvider.h"
#import "LCKMonster.h"

@implementation LCKMonsterProvider

+ (NSArray *)allMonsters {
    static NSArray *monsters;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *monsterArray = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Monsters" ofType:@"plist"];
        
        NSDictionary *monsterDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        [monsterDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *monsterName, NSDictionary *monsterDictionary, BOOL *stop) {
            LCKMonster *monster = [[LCKMonster alloc] initWithDictionary:monsterDictionary name:monsterName];
            
            [monsterArray addObject:monster];
        }];
        
        monsters = [monsterArray sortedArrayUsingComparator:^NSComparisonResult(LCKMonster *monster1, LCKMonster *monster2) {
            return [monster1.name localizedStandardCompare:monster2.name];
        }];
    });
    
    return monsters;
}

@end
