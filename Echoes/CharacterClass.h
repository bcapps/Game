//
//  CharacterClass.h
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <LCKCategories/NSManagedObject+LCKAdditions.h>

@import UIKit;

@interface CharacterClass : NSManagedObject

@property (nonatomic, retain) NSNumber * strength;
@property (nonatomic, retain) NSNumber * intelligence;
@property (nonatomic, retain) NSNumber * faith;
@property (nonatomic, retain) NSNumber * vitality;
@property (nonatomic, retain) NSNumber * dexterity;

@property (nonatomic, readonly) UIImage *classImage;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *classDescription;

+ (instancetype)newCharacterClassInContext:(NSManagedObjectContext *)context;

@end
