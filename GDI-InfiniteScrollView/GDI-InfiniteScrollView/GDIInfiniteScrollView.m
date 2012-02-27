//
//  GDIInfiniteScrollView.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDIInfiniteScrollView.h"

@interface GDIInfiniteScrollView()
@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic) NSUInteger maxNumberOfViewablePages;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *undistributedViewPositions;
@property (nonatomic) CGPoint lastTouchPoint;
@property (nonatomic) CGFloat velocity;
@property (nonatomic) NSUInteger leftIndex;
@property (nonatomic) NSUInteger rightIndex;
@property (strong, nonatomic) NSMutableArray *visiblePages;

- (void)setDefaults;
- (void)setDataSourceProperties;
- (void)buildVisiblePages;

- (void)trackTouch:(UITouch *)touch;
- (void)scrollViewByValue:(CGFloat)value;
- (void)distributeViews;
@end

@implementation GDIInfiniteScrollView
@synthesize delegate;
@synthesize dataSource;
@synthesize currentIndex;
@synthesize decelerationRate;
@synthesize distributionMethod;
@synthesize contentSize;

@synthesize numberOfPages = _numberOfPages;
@synthesize maxNumberOfViewablePages = _maxNumberOfViewablePages;
@synthesize viewControllers = _viewControllers;
@synthesize undistributedViewPositions = _undistributedViewPositions;
@synthesize lastTouchPoint = _lastTouchPoint;
@synthesize velocity = _velocity;
@synthesize leftIndex = _leftIndex;
@synthesize rightIndex = _rightIndex;
@synthesize visiblePages = _visiblePages;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDataSource:(NSObject<GDIInfiniteScrollViewDataSource> *)newDataSource
{
    dataSource = newDataSource;
    if (dataSource) {
        [self setDataSourceProperties];
        [self buildVisiblePages];
        [self distributeViews];
    }
}

- (void)setDefaults
{
    decelerationRate = .95f;
    distributionMethod = GDIInfiniteScrollViewDistributionMethodEqual;
    contentSize = self.frame.size;
    
    _viewControllers = [NSMutableArray array];
    _undistributedViewPositions = [NSMutableArray array];
    _visiblePages = [NSMutableArray array];
}

- (void)setDataSourceProperties
{
    currentIndex = 0;
    
    _numberOfPages = [dataSource numberOfPagesForInfiniteScrollView:self];
    _maxNumberOfViewablePages = [dataSource maxNumberOfViewablePagesForInfiniteScrollView:self];
}

#pragma mark - Adding View Controllers

- (void)addViewController:(UIViewController *)viewController
{
    [_viewControllers addObject:viewController];
}

#pragma mark - Build Methods

- (void)buildVisiblePages
{
    CGFloat dx = 0;
    for (int i=0; i < _numberOfPages && i < _maxNumberOfViewablePages; i++) {
        UIView *view = [dataSource viewForInfiniteScrollView:self atIndex:i];
        
        // store the position of this view as if it were directly next to the previous view.
        [self.undistributedViewPositions addObject:[NSNumber numberWithFloat:dx]];
        
        [self.visiblePages addObject:view];
        [self addSubview:view];
        
        dx += view.frame.size.width;
    }
}


#pragma mark - Scrolling

- (void)trackTouch:(UITouch *)touch
{
    CGPoint curTouchLoc = [touch locationInView:self];
    _velocity = curTouchLoc.x - _lastTouchPoint.x;
    
    [self scrollViewByValue:_velocity];
    
    _lastTouchPoint = curTouchLoc;
    NSLog(@"track touch lastLoc: %@, curLoc: %@, velocity: %.2f", NSStringFromCGPoint(_lastTouchPoint), NSStringFromCGPoint(curTouchLoc), _velocity);
}

- (void)scrollViewByValue:(CGFloat)value
{
    // manipulate the undistributed position values by the scroll value.
    for (int i=0; i < self.undistributedViewPositions.count; i++) {
        NSNumber *position = [self.undistributedViewPositions objectAtIndex:i];
        [self.undistributedViewPositions replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[position floatValue] + value]];
    }
    
    /*
    // remove views that have gone too far left
    CGFloat firstViewFrameRight = FLT_MIN;
    while(firstViewFrameRight < 0) {
        NSNumber *firstViewPosition = [self.undistributedViewPositions objectAtIndex:0];
        UIView *view = [self.visiblePages objectAtIndex:0];
        firstViewFrameRight = [firstViewPosition floatValue] + view.frame.size.width;
        
        if (firstViewFrameRight < 0) {
            [view removeFromSuperview];
            [self.undistributedViewPositions removeObjectAtIndex:0];
            [self.visiblePages removeObjectAtIndex:0];
        }
    }
    
    // remove views that have gone too far right
    CGFloat lastViewFrameLeft = FLT_MAX;
    while (lastViewFrameLeft > self.frame.size.width) {
        NSNumber *lastViewPosition = [self.undistributedViewPositions lastObject];
        UIView *view = [self.visiblePages lastObject];
        lastViewFrameLeft = [lastViewPosition floatValue] + view.frame.size.width;
        
        if (lastViewFrameLeft > self.frame.size.width) {
            [view removeFromSuperview];
            [self.undistributedViewPositions removeLastObject];
            [self.visiblePages removeLastObject];
        }
    }
    */
    // add views 
}

- (void)distributeViews
{
    // add up the width of all the displayed cells
    CGFloat totalWidth = 0;
    for (UIView *view in self.visiblePages) {
        totalWidth += view.frame.size.width;
    }
    
    // distribute views equally
    if (self.distributionMethod == GDIInfiniteScrollViewDistributionMethodEqual) {
        CGFloat dx = self.frame.size.width / self.visiblePages.count;
        
        for (int i=0; i<self.visiblePages.count; i++) {
            NSNumber *position = [self.undistributedViewPositions objectAtIndex:i];
            UIView *view = [self.visiblePages objectAtIndex:i];
            
            CGFloat viewX = (dx * i) + dx * .5 - view.frame.size.width * .5;
            
            view.frame = CGRectMake(viewX, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
    }
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        
        _lastTouchPoint = [touch locationInView:self];
        _velocity = 0;
        
        [self trackTouch:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        [self trackTouch:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


@end