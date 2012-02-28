//
//  DemoViewController.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDIInfiniteScrollViewController.h"

@interface DemoViewController : UIViewController <GDIInfiniteScrollViewControllerDelegate>
@property (strong, nonatomic) GDIInfiniteScrollViewController *infiniteScrollerVC;
@property (weak, nonatomic) IBOutlet UIView *infiniteScrollViewContainer;

@end
