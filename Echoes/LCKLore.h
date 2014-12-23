//
//  LCKLore.h
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCKLore : NSObject

- (instancetype)initWithTitle:(NSString *)title lore:(NSString *)lore;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *lore;

@end
