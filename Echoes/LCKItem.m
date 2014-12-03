//
//  LCKItem.m
//  Echoes
//
//  Created by Andrew Harrison on 12/3/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKItem.h"

NSString * const LCKItemNameKey = @"name";
NSString * const LCKItemActionKey = @"actionText";
NSString * const LCKItemDescriptionKey = @"descriptiveText";
NSString * const LCKItemFlavorKey = @"flavorText";
NSString * const LCKItemImageKey = @"imageName";
NSString * const LCKItemAttributeRequirementsKey = @"attributeRequirements";

@implementation LCKItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary objectForKey:LCKItemNameKey];
        _actionText = [dictionary objectForKey:LCKItemActionKey];
        _descriptionText = [dictionary objectForKey:LCKItemDescriptionKey];
        _flavorText = [dictionary objectForKey:LCKItemFlavorKey];
        _imageName = [dictionary objectForKey:LCKItemImageKey];
        _attributeRequirements = [dictionary objectForKey:LCKItemAttributeRequirementsKey];
    }
    
    return self;
}

@end
