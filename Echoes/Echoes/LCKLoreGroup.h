//
//  LCKLoreGroup.h
//  Echoes
//
//  Created by Andrew Harrison on 12/28/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCKLoreGroup : NSObject

@property (nonatomic, readonly) NSArray *loreArray;
@property (nonatomic, readonly) NSString *title;

- (instancetype)initWithDictionaryArray:(NSArray *)dictionaryArray title:(NSString *)title;

@end
