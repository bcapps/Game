//
//  LCKEvent.h
//  Echoes
//
//  Created by Andrew Harrison on 12/27/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@import Foundation;

@interface LCKEvent : NSObject

@property (nonatomic, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end
