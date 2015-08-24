//
//  DemoViewController.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIInfinitePageScrollViewController.h"

@interface DemoViewController : UIViewController <GDIInfinitePageScrollViewControllerDelegate>
@property (strong, nonatomic) GDIInfinitePageScrollViewController *infiniteScrollerVC;
@property (weak, nonatomic) IBOutlet UIView *infiniteScrollViewContainer;

@end
