//
//  LCKZoomableImageViewController.m
//  LCKiPhoneReader
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import "LCKZoomableImageViewController.h"
#import "LCKScalingImageView.h"

#import "UIColor+ColorStyle.h"

const CGFloat LCKScalingImageViewiPhoneMaxZoomScale = 1.5;
const CGFloat LCKScalingImageViewiPadMaxZoomScale = 2.0;

const CGFloat LCKScalingImageViewPinchDismissZoomScale = 0.75;

@interface LCKZoomableImageViewController ()

@property LCKScalingImageView *scalingImageView;
@property UIImage *image;

@property CGFloat minimumZoomScale;

@end

@implementation LCKZoomableImageViewController

#pragma mark - NSObject

- (void)dealloc {
    self.scalingImageView.delegate = nil;
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithImage:nil];
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.image = image;
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupScalingImageViewWithImage:(UIImage *)image {
    if (self.isViewLoaded && image) {
        
        [self.scalingImageView removeFromSuperview];
        
        self.scalingImageView = [[LCKScalingImageView alloc] initWithImage:image frame:self.view.bounds];
        self.scalingImageView.delegate = self;
        
        [self setupGestureRecognizers];
        
        [self.view addSubview:self.scalingImageView];
        [self.view sendSubviewToBack:self.scalingImageView];
        
        [self setupZoomScale];
    }
}

- (void)setupZoomScale {
    if (self.scalingImageView.internalImageView.image ) {
        CGRect scrollViewFrame = self.scalingImageView.frame;
        
        CGFloat scaleWidth = scrollViewFrame.size.width / self.scalingImageView.internalImageView.image.size.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.scalingImageView.internalImageView.image.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.minimumZoomScale = minScale;
        
        self.scalingImageView.minimumZoomScale = self.minimumZoomScale;
        self.scalingImageView.maximumZoomScale = LCKScalingImageViewiPhoneMaxZoomScale;
        
        self.scalingImageView.zoomScale = self.minimumZoomScale;
    }
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backgroundColor];
    
    [self setupScalingImageViewWithImage:self.image];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.scalingImageView.zoomScale = self.minimumZoomScale;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self setupZoomScale];
    
    //Center the content every time the view lays itself out.
    [self.scalingImageView centerScrollViewContents];
}

#pragma mark - UIGestureRecognizers

- (void)setupGestureRecognizers {
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scalingImageView addGestureRecognizer:doubleTapRecognizer];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.scalingImageView.internalImageView];
    
    CGFloat newZoomScale = self.scalingImageView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scalingImageView.maximumZoomScale);
    
    //If we've reached the maximum zoom scale, through double tapping, zoom back out.
    if (newZoomScale == self.scalingImageView.maximumZoomScale) {
        newZoomScale = self.scalingImageView.minimumZoomScale;
    }
    
    CGSize scrollViewSize = self.scalingImageView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat originX = pointInView.x - (width / 2.0f);
    CGFloat originY = pointInView.y - (height / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);
    
    [self.scalingImageView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scalingImageView.internalImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.scalingImageView centerScrollViewContents];
}

@end
