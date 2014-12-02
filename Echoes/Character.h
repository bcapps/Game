//
//  Character.h
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * race;

@end
