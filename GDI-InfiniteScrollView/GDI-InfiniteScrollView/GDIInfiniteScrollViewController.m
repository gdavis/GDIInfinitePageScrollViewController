//
//  GDIInfiniteScrollView.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIInfiniteScrollViewController.h"

@interface GDIInfiniteScrollViewController()
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger prevIndex;
@property (nonatomic) CGFloat actualContentWidth;

- (void)initializeView;

- (void)updateContentSize;
- (void)updateCurrentViewController;
- (void)updateCurrentIndex;

- (void)initFirstViewController;
- (void)initLastViewController;
- (void)initCurrentViewController;
- (void)loadPrevViewController;
- (void)loadNextViewController;

- (void)resetScrollToBeginning;
- (void)resetScrollToEnd;
- (void)unloadUnusedViewControllers;

- (void)layoutViews;

- (NSUInteger)indexOfPreviousController;
- (NSUInteger)indexOfNextController;

- (void)scrollToCurrentIndexWithAnimation:(BOOL)animate;

- (void)notifyDelegateOfCurrentIndexChange;

@end

@implementation GDIInfiniteScrollViewController

@synthesize pageViewControllers;
@synthesize currentIndex;
@synthesize scrollView = _scrollView;
@synthesize delegate;

@synthesize prevIndex = _prevIndex;
@synthesize viewControllers = _viewControllers;
@synthesize actualContentWidth = _actualContentWidth;


#pragma mark - View Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewControllers = [NSMutableArray array];
    }
    return self;
}


- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [self init];
    if (self) {
        _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewControllers = [NSMutableArray array];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self unloadUnusedViewControllers];
}


- (void)loadView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.view = self.scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.f;
    self.scrollView.maximumZoomScale = 1.f;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.decelerationRate = .1f;
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self layoutViews];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.frame = self.view.superview.bounds;    
    [self initializeView];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    [self.scrollView removeFromSuperview];
    _scrollView = nil;
}


- (void)initializeView
{    
    [self updateContentSize];
    [self scrollToCurrentIndexWithAnimation:NO];
}

#pragma mark - Public Methods


- (void)setPageViewControllers:(NSArray *)controllers
{
    self.viewControllers = [NSMutableArray arrayWithArray:controllers];
}


- (void)setCurrentIndex:(NSUInteger)index animation:(BOOL)animate
{
    if (index > _viewControllers.count-1) {
        index = _viewControllers.count-1;
    }
    
    currentIndex = index;
    
    [self notifyDelegateOfCurrentIndexChange];
    [self scrollToCurrentIndexWithAnimation:animate];
}


#pragma mark - View Controller Management


- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    // remove previous
    for (UIViewController *vc in _viewControllers) {
        [vc.view removeFromSuperview];
    }
    
    currentIndex = 0;
    _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
    
    [self initializeView];
}


- (void)initFirstViewController
{
    UIViewController *viewController = [_viewControllers objectAtIndex:0];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}


- (void)initLastViewController
{
    UIViewController *viewController = [_viewControllers lastObject];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * _viewControllers.count, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}

- (void)initCurrentViewController
{
    UIViewController *viewController = [_viewControllers objectAtIndex:self.currentIndex];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width + self.currentIndex * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}


- (void)loadPrevViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    NSInteger prevIndex = [self indexOfPreviousController];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:prevIndex];
    [self.scrollView addSubview:viewController.view];
    
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x - self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


- (void)loadNextViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    NSInteger nextIndex = [self indexOfNextController];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:nextIndex];
    [self.scrollView addSubview:viewController.view];
    
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x + self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


- (void)updateCurrentViewController
{
    NSInteger delta = self.currentIndex - self.prevIndex;
    // determine if we've moved more than one index, which means we
    // need to reset to the beginning or the end of the view
    if (abs(delta) > 1) {
        if (delta < 0) {
            [self resetScrollToBeginning];
        }
        else {
            [self resetScrollToEnd];
        }
    }
    else {
        // determine which direction we are moving in, 
        // and build the upcoming view controller for that direction.
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


- (void)unloadUnusedViewControllers
{
    for (int i=0; i < _viewControllers.count; i++) {
        if (i != self.currentIndex && i != [self indexOfPreviousController] && i != [self indexOfNextController]) {
            UIViewController *vc = [_viewControllers objectAtIndex:i];
            if (vc.view) {
                [vc.view removeFromSuperview];
                vc.view = nil;
                [vc viewDidUnload];
            }
        }
    }
}


- (NSUInteger)indexOfPreviousController
{
    NSInteger prevIndex = self.currentIndex-1;
    if (prevIndex < 0) {
        prevIndex = self.viewControllers.count-1;
    }
    return prevIndex;
}


- (NSUInteger)indexOfNextController
{
    NSInteger nextIndex = self.currentIndex+1;
    if (nextIndex >= self.viewControllers.count) {
        nextIndex = 0;
    }
    return nextIndex;
}

#pragma mark - Scroll View Management


- (void)scrollToCurrentIndexWithAnimation:(BOOL)animate
{
    CGPoint offsetPoint = CGPointMake(self.scrollView.frame.size.width + self.scrollView.frame.size.width * self.currentIndex, 0);
    [self.scrollView setContentOffset:offsetPoint animated:animate];
    [self initCurrentViewController];
}


- (void)updateContentSize
{
    // the content size is extended beyond the size actually needed to display all the added view controllers.
    // we add the size of two extra pages, one for the front of the scrollview, the other for the end, to create
    // the seamless tiling effect. for example, with 10 pages, the index values would look like:
    // 9, 0, 1 ... 8, 9, 0
    CGFloat wv = (self.viewControllers.count + 2) * self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(wv, self.scrollView.frame.size.height);
    self.actualContentWidth = self.viewControllers.count * self.scrollView.frame.size.width;
}


- (void)updateCurrentIndex
{
    // calculate the current index and account for the extra page spaces we've added for infinite scrolling
    NSInteger index = roundf((self.scrollView.contentOffset.x - self.scrollView.frame.size.width) / self.scrollView.frame.size.width);
    
    if (index < 0) {
        index = self.viewControllers.count-1;
    }
    if (index >= _viewControllers.count) {
        index = 0;
    }
    
    self.currentIndex = index;
}

- (void)layoutViews
{
    for (UIViewController *vc in _viewControllers) {
        vc.view.frame = CGRectMake(vc.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


- (void)setCurrentIndex:(NSUInteger)newIndex
{
    if (currentIndex == newIndex) {
        return;
    }
    _prevIndex = currentIndex;
    currentIndex = newIndex;
    [self notifyDelegateOfCurrentIndexChange];
    [self updateCurrentViewController];
}


- (void)resetScrollToBeginning
{
    CGFloat offset = fmodf(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) - 1;
    self.scrollView.contentOffset = CGPointMake(offset, 0);
    [self initFirstViewController];
}


- (void)resetScrollToEnd
{
    CGFloat offset = fmodf(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) - 1;
    self.scrollView.contentOffset = CGPointMake(self.viewControllers.count * self.scrollView.frame.size.width + offset, 0);
    [self initLastViewController];
}

- (void)notifyDelegateOfCurrentIndexChange
{
    if ([delegate respondsToSelector:@selector(infiniteScrollViewDidScrollToIndex:)]) {
        [delegate infiniteScrollViewDidScrollToIndex:self.currentIndex];
    }
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    [self updateCurrentIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // this line fixes a bug that would occur after resetting the scroll view to the end,
    // quickly swiping again, and the scroll view would skip past an entire page.
    [self.scrollView setContentOffset:self.scrollView.contentOffset animated:NO];
}

@end





