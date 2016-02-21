//
//  NSString+LCKAdditions.m
//  Quotebook
//
//  Created by Matthew Bischoff on 1/4/14.
//
//

#import "NSString+LCKAdditions.h"

@implementation NSString (LCKAdditions)

- (NSString *)whitespaceAndNewlineTrimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSRange)fullRange {
    return NSMakeRange(0, [self length]);
}

- (NSString *)stringWithoutParentheses {
    NSString *stringWithoutParentheses = [self copy];

    NSString *expression = @"\\s+\\([^()]*\\)";
    
    while ([stringWithoutParentheses rangeOfString:expression options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location!=NSNotFound) {
        stringWithoutParentheses = [stringWithoutParentheses stringByReplacingOccurrencesOfString:expression withString:@"" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch range:NSMakeRange(0, [stringWithoutParentheses length])];
    }
    
    return stringWithoutParentheses;
}

- (NSString *)URLEncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]%"),
                                                                                 kCFStringEncodingUTF8));
}

- (BOOL)isTwitterUsername {
    return [self hasPrefix:@"@"];
}

- (BOOL)containsSubstring:(NSString *)substring {
    return [self containsSubstring:substring reverse:NO];
}

- (BOOL)containsSubstring:(NSString *)substring reverse:(BOOL)reverse {
    NSStringCompareOptions options = 0;
    
    if (reverse) {
        options = NSBackwardsSearch;
    }
    
    if ([substring length] && [self rangeOfString:substring options:options].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (NSString *)safeSubstringToIndex:(NSUInteger)anIndex {
    if (anIndex >= [self length]) {
        return self;
    }
    
    return [self substringToIndex:anIndex];
}

- (NSString *)safeSubstringFromIndex:(NSUInteger)anIndex {
    if (anIndex >= [self length]) {
        // the starting location is beyond the end of self
        return nil;
    }
    
    return [self substringFromIndex:anIndex];
}

- (NSString *)safeSubstringWithRange:(NSRange)aRange {
    if (aRange.location >= [self length]) {
        //the starting location is beyond the end of self
        return nil;
    }
    
    if (NSMaxRange(aRange) >= [self length]) {
        //the starting location is OK, but the length requested goes beyond the end of self
        return [self substringFromIndex:aRange.location];
    }
    
    return [self substringWithRange:aRange];
}

@end
