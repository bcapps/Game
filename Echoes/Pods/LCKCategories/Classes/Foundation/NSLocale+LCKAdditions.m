//
//  NSLocale+LCKAdditions.m
//  Pods
//
//  Created by Matthew Bischoff on 7/20/14.
//
//

#import "NSLocale+LCKAdditions.h"

@implementation NSLocale (LCKAdditions)

+ (NSString *)perferredLangaugeCode {
    NSString *preferredLanguage = [[NSLocale preferredLanguages] firstObject];
    NSLocale *preferredLanguageLocale = [[NSLocale alloc] initWithLocaleIdentifier:preferredLanguage];
    
    NSString *languageCode = [preferredLanguageLocale objectForKey:NSLocaleLanguageCode];
    if (!languageCode) {
        languageCode = [[NSLocale systemLocale] objectForKey:NSLocaleLanguageCode];
    }
    
    return languageCode;
}

@end
