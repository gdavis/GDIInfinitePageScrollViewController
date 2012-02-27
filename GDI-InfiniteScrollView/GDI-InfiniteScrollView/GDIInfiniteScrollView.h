//
//  GDIInfiniteScrollView.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDIInfiniteScrollViewDelegate, GDIInfiniteScrollViewDataSource;

typedef enum GDIInfiniteScrollViewDistributionMethod {
    GDIInfiniteScrollViewDistributionMethodEqual = 0,
    GDIInfiniteScrollViewDistributionMethodEdges = 1, // views on the left align left, current view gets centered, and right views align right
} GDIInfiniteScrollViewDistributionMethod;


@interface GDIInfiniteScrollView : UIView
@property (weak, nonatomic) NSObject <GDIInfiniteScrollViewDelegate> *delegate;
@property (weak, nonatomic) NSObject <GDIInfiniteScrollViewDataSource> *dataSource;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) CGFloat decelerationRate;
@property (nonatomic) GDIInfiniteScrollViewDistributionMethod distributionMethod;
@property (nonatomic) CGSize contentSize;

// adds a view controller to display on a page
- (void)addViewController:(UIViewController *)viewController;

@end


@protocol GDIInfiniteScrollViewDelegate
- (void)infiniteScrollView:(GDIInfiniteScrollView *)scrollView didSelectIndex:(NSUInteger)index;
@end


@protocol GDIInfiniteScrollViewDataSource
- (NSUInteger)numberOfPagesForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView;
- (NSUInteger)maxNumberOfViewablePagesForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView;
- (UIView *)viewForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView atIndex:(NSUInteger)index;
@end