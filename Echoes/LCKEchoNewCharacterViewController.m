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

CGFloat const LCKEchoNewCharacterViewControllerClassPickerVerticalOffset = -100;
CGFloat const LCKEchoNewCharacterViewControllerCarouselRadius = 140.0;
CGFloat const LCKEchoNewCharacterViewControllerCarouselItemSize = 90.0;

@interface LCKEchoNewCharacterViewController () <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *classPicker;

@property (nonatomic, readonly) NSArray *classes;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@end

@implementation LCKEchoNewCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classPicker.type = iCarouselTypeWheel;
    self.classPicker.contentOffset = CGSizeMake(0, LCKEchoNewCharacterViewControllerClassPickerVerticalOffset);
    
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
        return LCKEchoNewCharacterViewControllerCarouselRadius;
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
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LCKEchoNewCharacterViewControllerCarouselItemSize, LCKEchoNewCharacterViewControllerCarouselItemSize)];
    itemView.layer.masksToBounds = NO;
    itemView.clipsToBounds = YES;
    itemView.layer.borderWidth = 1.0;
    itemView.layer.borderColor = [UIColor whiteColor].CGColor;
    itemView.layer.cornerRadius = CGRectGetHeight(itemView.frame) / 2.0;
    
    CharacterClass *characterClass = [self.classes safeObjectAtIndex:index];
    
    UIImageView *classImageView = [[UIImageView alloc] initWithImage:characterClass.classImage];
    classImageView.frame = itemView.frame;
    classImageView.contentMode = UIViewContentModeScaleToFill;
    classImageView.backgroundColor = [UIColor clearColor];
    classImageView.center = itemView.center;
    
    [itemView addSubview:classImageView];
    
    return itemView;
}

@end
