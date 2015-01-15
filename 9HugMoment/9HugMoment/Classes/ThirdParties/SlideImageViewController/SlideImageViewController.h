//
//  SlideImageViewController.h
//  DepVD
//
//  Created by Quynh Nguyen on 7/17/14.
//  Copyright (c) 2014 Quynh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideImageViewController : UIViewController
@property (nonatomic, retain) NSMutableArray *arrImages;
- (id)initWithIndex:(NSInteger)index;
@end
