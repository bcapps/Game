//
//  LCKMonster.h
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCKMonster : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSNumber *AC;
@property (nonatomic, readonly) NSNumber *health;
@property (nonatomic, readonly) NSNumber *hitNumber;
@property (nonatomic, readonly) NSArray *attacks;
@property (nonatomic, readonly) NSArray *attributes;

@end
