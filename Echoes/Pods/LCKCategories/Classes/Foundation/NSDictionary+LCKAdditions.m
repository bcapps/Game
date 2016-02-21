//
//  NSDictionary+LCKAdditions.m
//  Antenna
//
//  Created by Grant Butler on 7/20/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "NSDictionary+LCKAdditions.h"

@implementation NSDictionary (LCKAdditions)

- (NSString *)stringForKey:(id <NSCopying>)key {
    return [self objectOfClass:[NSString class] forKey:key];
}

- (NSArray *)arrayForKey:(id <NSCopying>)key {
    return [self objectOfClass:[NSArray class] forKey:key];
}

- (NSNumber *)numberForKey:(id <NSCopying>)key {
    return [self objectOfClass:[NSNumber class] forKey:key];
}

- (NSDictionary *)dictionaryForKey:(id <NSCopying>)key {
    return [self objectOfClass:[NSDictionary class] forKey:key];
}

- (NSSet *)setForKey:(id <NSCopying>)key {
    return [self objectOfClass:[NSSet class] forKey:key];
}

- (id)objectOfClass:(Class)class forKey:(id <NSCopying>)key {
    id object = self[key];
    if (![object isKindOfClass:class]) {
        return nil;
    }
    return object;
}

@end
