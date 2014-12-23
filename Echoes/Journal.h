//
//  Journal.h
//  Echoes
//
//  Created by Andrew Harrison on 12/22/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, JournalEntry;

@interface Journal : NSManagedObject

@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Journal (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(JournalEntry *)value;
- (void)removeEntriesObject:(JournalEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
