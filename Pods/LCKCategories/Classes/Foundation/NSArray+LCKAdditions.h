//
//  NSArray+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 1/6/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LCKAdditions)

/// Returns the object at the index or nil if the index is out of bounds.
- (id)safeObjectAtIndex:(NSUInteger)index;

- (id)firstObjectOfClass:(Class)aClass;
- (NSArray *)objectsOfClass:(Class)aClass;
- (BOOL)containsObjectOfClass:(Class)aClass;

@end
