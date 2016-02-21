//
//  LCKLore.h
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;

@interface LCKLore : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *lore;

@end
