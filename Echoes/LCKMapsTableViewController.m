//
//  LCKMapsTableViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/23/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKMapsTableViewController.h"
#import "LCKBaseCell.h"
#import "LCKZoomableImageViewController.h"
#import "UIColor+ColorStyle.h"

#import <NSArray+LCKAdditions.h>

@interface LCKMapsTableViewController ()

@property (nonatomic) NSArray *mapNames;

@end

@implementation LCKMapsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapNames = @[@"CatacombsMap",
                      @"FirelinkShrineMap",
                      @"NewLondoRuinsMap",
                      @"UndeadAsylumMap",
                      @"UndeadBurgMap",
                      @"UpperBlighttownMap",
                      @"ValleyOfDrakesMap",
                      @"UndeadParishExterior",
                      @"UndeadParishInterior",
                      @"DarkrootBasin"];
    [self.mapNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    [self.tableView registerClass:[LCKBaseCell class] forCellReuseIdentifier:NSStringFromClass([LCKBaseCell class])];
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mapNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCKBaseCell class]) forIndexPath:indexPath];
    
    NSString *mapName = [self.mapNames safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = mapName;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *mapName = [self.mapNames safeObjectAtIndex:indexPath.row];
    UIImage *mapImage = [UIImage imageNamed:mapName];
    
    LCKZoomableImageViewController *mapImageViewController = [[LCKZoomableImageViewController alloc] initWithImage:mapImage];
    mapImageViewController.title = mapName;
    
    [self.navigationController pushViewController:mapImageViewController animated:YES];
}

@end
