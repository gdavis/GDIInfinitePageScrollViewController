//
//  GDIInfiniteScrollView.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDIInfiniteScrollViewControllerDelegate;

@interface GDIInfiniteScrollViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *pageViewControllers;
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (weak, nonatomic) NSObject <GDIInfiniteScrollViewControllerDelegate> *delegate;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)setCurrentPageIndex:(NSUInteger)index;

@end


@protocol GDIInfiniteScrollViewControllerDelegate
- (void)infiniteScrollViewDidScrollToIndex:(NSUInteger)index;
- (void)infiniteScrollViewDidScrollToRawIndex:(CGFloat)index; // decimal value of the position of the view.
@end