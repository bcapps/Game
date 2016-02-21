//
//  NSLocale+LCKAdditions.h
//  Pods
//
//  Created by Matthew Bischoff on 7/20/14.
//
//

@import Foundation;

@interface NSLocale (LCKAdditions)

/**
 *  Returns a two letter language code (ISO-639-1) corresponding to the user’s preferred language.
 *
 *  @see http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
 *  @return The code of the preferred language or the sytem language if no preferred language exits.
 */
+ (NSString *)perferredLangaugeCode;

@end
