//
//  UITableViewController+LCKRestoration.m
//  Velocity
//
//  Created by Matthew Bischoff on 8/6/13.
//  Copyright (c) 2013 Lickability. All rights reserved.
//

#import "UITableViewController+LCKRestoration.h"

@implementation UITableViewController (LCKRestoration)

- (NSString *)restorationIdentifierForTableView {
    return [self.restorationIdentifier stringByAppendingString:@"TableView"];
}

@end
