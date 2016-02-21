//
//  NSError+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 4/13/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

@interface NSError (LCKAdditions)

+ (NSDictionary *)errorUserInfoWithDescription:(NSString *)description failureReason:(NSString *)failureReason recoverySuggestion:(NSString *)recoverySuggestion underlyingError:(NSError *)underlyingError;
- (void)logToConsole;

@end
