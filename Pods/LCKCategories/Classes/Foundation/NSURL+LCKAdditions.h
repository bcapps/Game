//
//  NSURL+LCKAdditions.h
//  Quotebook
//
//  Created by Matthew Bischoff on 1/5/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (LCKAdditions)

- (BOOL)isHTTP;
- (BOOL)isHTTPS;
- (BOOL)isHTTPOrHTTPS;


@end
