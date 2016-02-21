//
//  LCKMonster.h
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface LCKMonster : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary name:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *AC;
@property (nonatomic, readonly) NSNumber *health;
@property (nonatomic, readonly) NSNumber *hitNumber;
@property (nonatomic, readonly) NSNumber *soulValue;
@property (nonatomic, readonly) NSArray *attacks;
@property (nonatomic, readonly) NSArray *attributes;

@property (nonatomic, readonly) BOOL hasSignalAttacks;
@property (nonatomic, readonly) UIImage *image;

@end
