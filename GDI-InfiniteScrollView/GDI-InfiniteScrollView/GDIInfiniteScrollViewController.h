//
//  GDIInfiniteScrollView.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDIInfiniteScrollViewControllerDelegate;

@interface GDIInfiniteScrollViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *pageViewControllers;
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (weak, nonatomic) NSObject <GDIInfiniteScrollViewControllerDelegate> *delegate;

- (id)initWithViewControllers:(NSArray *)viewControllers;

- (void)setCurrentIndex:(NSUInteger)index animation:(BOOL)animate;

@end


@protocol GDIInfiniteScrollViewControllerDelegate
@end