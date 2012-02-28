//
//  GDIInfiniteScrollView.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIInfiniteScrollView.h"

@interface GDIInfiniteScrollView()
@property (nonatomic) NSUInteger prevIndex;
@property (nonatomic) CGFloat actualContentWidth;

- (void)initialize;
- (void)updateContentSize;
- (void)updateCurrentViewController;
- (void)updateCurrentIndex;
- (void)initFirstViewController;
- (void)initLastViewController;
- (void)loadPrevViewController;
- (void)loadNextViewController;
- (void)resetScrollToBeginning;
- (void)resetScrollToEnd;

@end

@implementation GDIInfiniteScrollView

@synthesize currentIndex;

@synthesize prevIndex = _prevIndex;
@synthesize viewControllers = _viewControllers;
@synthesize actualContentWidth = _actualContentWidth;


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers
{
    self = [self initWithFrame:frame];
    if (self) {
        _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
        [self updateContentSize];
    }
    return self;
}

- (void)initialize
{
    self.delegate = self;
    super.pagingEnabled = YES;
    _viewControllers = [NSMutableArray array];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    // don't allow anything but paging.
    [super setPagingEnabled:YES];
}

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
    currentIndex = 0;
    
    [self updateContentSize];
    [self initFirstViewController];
    
    // center the scroll view on the first index.
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
}

#pragma mark - View Controller Management

- (void)updateContentSize
{
    // the content size is extended beyond the size actually needed to display all the added view controllers.
    // we add the size of two extra pages, one for the front of the scrollview, the other for the end, to create
    // the seamless tiling effect. for example, with 10 pages, the index values would look like:
    // 9, 0, 1 ... 8, 9, 0
    
    CGFloat wv = (self.viewControllers.count + 2) * self.frame.size.width;
    self.contentSize = CGSizeMake(wv, self.frame.size.height);
    self.actualContentWidth = self.viewControllers.count * self.frame.size.width;
}


- (void)initFirstViewController
{
    UIViewController *viewController = [_viewControllers objectAtIndex:0];
    [self addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.contentSize.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}

- (void)initLastViewController
{
    UIViewController *viewController = [_viewControllers lastObject];
    [self addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.frame.size.width * _viewControllers.count, 0, self.frame.size.width, self.contentSize.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}

- (void)updateCurrentViewController
{
    NSInteger delta = self.currentIndex - self.prevIndex;
    if (abs(delta) > 1) {
        if (delta < 0) {
            [self resetScrollToBeginning];
        }
        else {
            [self resetScrollToEnd];
        }
    }
    else {
        // determine which direction we are moving in, and build the upcoming view controller for that direction.
        if (self.currentIndex < self.prevIndex) {
            // moving left, backwards
            [self loadPrevViewController];
        }
        
        if (self.currentIndex > self.prevIndex) {
            // moving right, forwards
            [self loadNextViewController];
        }
    }
}


- (void)loadPrevViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    NSInteger prevIndex = self.currentIndex-1;
    if (prevIndex < 0) {
        prevIndex = self.viewControllers.count-1;
    }
//    NSLog(@"loading prev vc, current index: %i, prev index: %i", self.currentIndex, prevIndex);
    UIViewController *viewController = [self.viewControllers objectAtIndex:prevIndex];
    [self addSubview:viewController.view];
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}


- (void)loadNextViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    // moving right, forwards
    NSInteger nextIndex = self.currentIndex+1;
    if (nextIndex >= self.viewControllers.count) {
        nextIndex = 0;
    }
//    NSLog(@"loading next vc, current index: %i, next index: %i", self.currentIndex, nextIndex);
    UIViewController *viewController = [self.viewControllers objectAtIndex:nextIndex];
    [self addSubview:viewController.view];
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}


- (void)updateCurrentIndex
{
    // calculate the current index and account for the extra page spaces we've added for infinite scrolling
    NSInteger index = roundf((self.contentOffset.x - self.frame.size.width) / self.frame.size.width);
    
    if (index < 0) {
        index = self.viewControllers.count-1;
    }
    if (index >= _viewControllers.count) {
        index = 0;
    }
    
    self.currentIndex = index;
}

- (void)setCurrentIndex:(NSUInteger)newIndex
{
    if (currentIndex == newIndex) {
        return;
    }
    _prevIndex = currentIndex;
    currentIndex = newIndex;
    [self updateCurrentViewController];
}

- (void)resetScrollToBeginning
{
    CGFloat offset = fmodf(self.contentOffset.x, self.frame.size.width) - 1;
    self.contentOffset = CGPointMake(offset, 0);

    [self initFirstViewController];
}

- (void)resetScrollToEnd
{
    CGFloat offset = fmodf(self.contentOffset.x, self.frame.size.width) - 1;
    self.contentOffset = CGPointMake(self.viewControllers.count * self.frame.size.width + offset, 0);

    [self initLastViewController];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    [self updateCurrentIndex];
}


@end