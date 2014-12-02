//
//  NSError+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 4/13/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "NSError+LCKAdditions.h"

@implementation NSError (LCKAdditions)

+ (NSDictionary *)errorUserInfoWithDescription:(NSString *)description failureReason:(NSString *)failureReason recoverySuggestion:(NSString *)recoverySuggestion underlyingError:(NSError *)underlyingError {
    NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionary];
    
    [errorUserInfo setValue:description forKey:NSLocalizedDescriptionKey];
    [errorUserInfo setValue:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    [errorUserInfo setValue:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
    [errorUserInfo setValue:underlyingError forKey:NSUnderlyingErrorKey];
    
    return [errorUserInfo copy];
}

- (void)logToConsole {
    NSLog(@"%@", self);
}

@end
