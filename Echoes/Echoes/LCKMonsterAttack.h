//
//  LCKMonsterAttack.h
//  Echoes
//
//  Created by Andrew Harrison on 12/16/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCKMonsterAttack : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString *diceRoll;
@property (nonatomic, readonly) NSString *attackName;
@property (nonatomic, readonly) NSString *attackDescription;

@property (nonatomic, getter=isSignalAttack) BOOL signalAttack;

@end
