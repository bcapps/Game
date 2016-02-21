//
//  LCKZoomableImageViewController.h
//  NYTiPhoneReader
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

@import UIKit;

@interface LCKZoomableImageViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/**----------------------------------------------------------
 * @name initWithImage:
 *  ---------------------------------------------------------
 */

/** Initializes and NYTZoomableImageViewController with an NYTImage object.
 
 @param NYTImage An NYTImage object that initializes the NYTZoomableImageViewController
 @return An initialized NYTZoomableImageViewController.
 */
- (instancetype)initWithImage:(UIImage *)image;

/**----------------------------------------------------------
 * @name setupScalingImageViewWithImage:
 *  ---------------------------------------------------------
 */

/** This method is called by default on initialization. However, you will need to call this method if the UIImage object inside the NYTImage object has not been downloaded yet. You can use this method to setup the NYTZoomableImageViewController without having to reinitialize it.
 
 @param NYTImage An NYTImage object
 */
- (void)setupScalingImageViewWithImage:(UIImage *)image;

@end
