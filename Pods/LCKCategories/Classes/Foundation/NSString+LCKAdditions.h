//
//  NSString+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (LCKAdditions)

- (NSString *)whitespaceAndNewlineTrimmedString;
- (NSRange)fullRange;

- (NSString *)stringWithoutParentheses;
- (NSString *)URLEncodedString;

/// Returns nil if the substring if the range is out of bounds.
- (NSString *)safeSubstringWithRange:(NSRange)range;

/// Returns YES if the string begins with @
- (BOOL)isTwitterUsername;

- (BOOL)containsSubstring:(NSString *)substring;
- (BOOL)containsSubstring:(NSString *)substring reverse:(BOOL)reverse;

- (NSString *)safeSubstringToIndex:(NSUInteger)anIndex;
- (NSString *)safeSubstringFromIndex:(NSUInteger)anIndex;
- (NSString *)safeSubstringWithRange:(NSRange)aRange;

@end
