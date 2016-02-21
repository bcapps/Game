//
//  NSDictionary+LCKAdditions.h
//  Antenna
//
//  Created by Grant Butler on 7/20/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LCKAdditions)

/// Returns the NSString value for the specified key, or nil if it's not an NSString instance.
- (NSString *)stringForKey:(id <NSCopying>)key;

/// Returns the NSArray value for the specified key, or nil if it's not an NSArray instance.
- (NSArray *)arrayForKey:(id <NSCopying>)key;

/// Returns the NSNumber value for the specified key, or nil if it's not an NSNumber instance.
- (NSNumber *)numberForKey:(id <NSCopying>)key;

/// Returns the NSDictionary value for the specified key, or nil if it's not an NSDictionary instance.
- (NSDictionary *)dictionaryForKey:(id <NSCopying>)key;

/// Returns the NSSet value for the specified key, or nil if it's not an NSSet instance.
- (NSSet *)setForKey:(id <NSCopying>)key;

/// Returns the object for the specified key if it's of the given class, or nil if it's not.
- (id)objectOfClass:(Class)class forKey:(id <NSCopying>)key;

@end
