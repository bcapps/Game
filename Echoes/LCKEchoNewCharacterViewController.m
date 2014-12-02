//
//  LCKEchoNewCharacterViewController.m
//  Echoes
//
//  Created by Andrew Harrison on 12/1/14.
//  Copyright (c) 2014 Lickability. All rights reserved.
//

#import "LCKEchoNewCharacterViewController.h"
#import "LCKEchoCoreDataController.h"
#import "CharacterClasses.h"

#import <iCarousel/iCarousel.h>

#import <LCKCategories/NSManagedObject+LCKAdditions.h>
#import <LCKCategories/NSArray+LCKAdditions.h>

@interface LCKEchoNewCharacterViewController () <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *classPicker;

@property (nonatomic, readonly) NSArray *classes;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@end

@implementation LCKEchoNewCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classPicker.type = iCarouselTypeWheel;
    self.classPicker.contentOffset = CGSizeMake(0, -100);
    
    self.view.backgroundColor = [UIColor blackColor];
    self.classPicker.backgroundColor = [UIColor blackColor];
    
    self.classNameLabel.textColor = [UIColor whiteColor];
}

- (NSArray *)classes {
    NSManagedObjectContext *context = [[LCKEchoCoreDataController sharedController] newWorkerContext];
    
    Thief *thief = [[Thief alloc] initWithContext:context];
    Cleric *cleric = [[Cleric alloc] initWithContext:context];
    Warrior *warrior = [[Warrior alloc] initWithContext:context];
    Sorcerer *sorcerer = [[Sorcerer alloc] initWithContext:context];
    Bandit *bandit = [[Bandit alloc] initWithContext:context];
    Hunter *hunter = [[Hunter alloc] initWithContext:context];
    Knight *knight = [[Knight alloc] initWithContext:context];
    
    return @[thief, cleric, warrior, sorcerer, bandit, hunter, knight];
}

#pragma mark - iCarouselDelegate

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionRadius) {
        return 140.0;
    }
    
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    CharacterClass *characterClass = [self.classes safeObjectAtIndex:index];

    self.classNameLabel.text = characterClass.className;
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.classes.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CGFloat size = 90.0;

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    v.layer.masksToBounds = NO;
    v.clipsToBounds = YES;
    v.layer.borderWidth = 1.0;
    v.layer.borderColor = [UIColor whiteColor].CGColor;
    v.layer.cornerRadius = CGRectGetHeight(v.frame) / 2.0;
    
    CharacterClass *characterClass = [self.classes safeObjectAtIndex:index];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:characterClass.classImage];
    imgView.frame = v.frame;
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.backgroundColor = [UIColor clearColor];
    imgView.center = v.center;
    
    [v addSubview:imgView];
    
    return v;
}

@end
