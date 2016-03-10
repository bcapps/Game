//
//  LCKMultipeerMessage.m
//  Echoes
//
//  Created by Andrew Harrison on 11/4/15.
//  Copyright © 2015 Lickability. All rights reserved.
//

#import "LCKMultipeerMessage.h"

static NSString * const LCKMultipeerMessageTypeKey = @"LCKMultipeerMessageTypeKey";
static NSString * const LCKMultipeerMessageDataKey = @"LCKMultipeerMessageDataKey";

@interface LCKMultipeerMessage ()

@property (nonatomic) NSUInteger type;
@property (nonatomic) NSData *data;

@end

@implementation LCKMultipeerMessage

#pragma mark - LCKMultipeerMessage

- (instancetype)initWithMessageType:(NSUInteger)type messageData:(NSData *)data {
    self = [super init];
    
    if (self) {
        _type = type;
        _data = data;
    }
    
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    
    if (self) {
        _type = [coder decodeIntegerForKey:LCKMultipeerMessageTypeKey];
        _data = [coder decodeObjectForKey:LCKMultipeerMessageDataKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.type forKey:LCKMultipeerMessageTypeKey];
    [coder encodeObject:self.data forKey:LCKMultipeerMessageDataKey];
}

@end
