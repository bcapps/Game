//
//  LCKLoreGroup.m
//  Echoes
//
//  Created by Andrew Harrison on 12/28/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKLoreGroup.h"
#import "LCKLore.h"

@implementation LCKLoreGroup

- (instancetype)initWithDictionaryArray:(NSArray *)dictionaryArray title:(NSString *)title {
    self = [super init];
    
    if (self) {
        _title = title;
        
        NSMutableArray *loreArray = [NSMutableArray array];
        
        for (NSDictionary *loreDictionary in dictionaryArray) {
            LCKLore *lore = [[LCKLore alloc] initWithDictionary:loreDictionary];
            
            [loreArray addObject:lore];
        }
        
        _loreArray = [loreArray copy];
    }
    
    return self;
}

@end
