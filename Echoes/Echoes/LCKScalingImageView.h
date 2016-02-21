//
//  LCKScalingImageView.h
//  NYTiPhoneReader
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

@import UIKit;

@interface LCKScalingImageView : UIScrollView

@property UIImageView *internalImageView;

/**----------------------------------------------------------
 * @name initWithImage:frame:
 *  ---------------------------------------------------------
 */

/** Initializes a scaling image view with a UIImage. This object is a UIScrollView that contains a UIImageView. This allows for zooming and panning around the image. Additionally it supports double tap to zoom.
 
 @param UIImage A UIImage object.
 @param CGRect  The frame to initialize the NYTScalingImageView in.
 @return Whatever it returns.
 */
- (id)initWithImage:(UIImage *)image frame:(CGRect)frame;

/**----------------------------------------------------------
 * @name centerScrollViewContents
 *  ---------------------------------------------------------
 */

/** Centers the image inside of the scroll view. Typically used after rotation, or when zooming has finished.
 */
- (void)centerScrollViewContents;

@end
