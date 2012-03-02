//
//  DemoViewController.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "DemoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentViewController.h"

@implementation DemoViewController
@synthesize infiniteScrollerVC;
@synthesize infiniteScrollViewContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ContentViewController *pageOneVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    ContentViewController *pageTwoVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    ContentViewController *pageThreeVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    ContentViewController *pageFourVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    ContentViewController *pageFiveVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];

    pageOneVC.labelText = @"0";
    pageTwoVC.labelText = @"1";
    pageThreeVC.labelText = @"2";
    pageFourVC.labelText = @"3";
    pageFiveVC.labelText = @"4";
    
    infiniteScrollerVC = [[GDIInfinitePageScrollViewController alloc] initWithViewControllers:[NSArray arrayWithObjects:pageOneVC, pageTwoVC, pageThreeVC, pageFourVC, pageFiveVC, nil]];

    
    infiniteScrollerVC.delegate = self;
    [self.infiniteScrollViewContainer addSubview:infiniteScrollerVC.view];
    self.infiniteScrollerVC.view.frame = self.infiniteScrollViewContainer.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setInfiniteScrollViewContainer:nil];
    [super viewDidUnload];
}


- (void)infiniteScrollViewDidScrollToIndex:(NSUInteger)index
{
    NSLog(@"infiniteScrollViewDidScrollToIndex: %i", index);
}

- (void)infiniteScrollViewDidScrollToRawIndex:(CGFloat)index
{
//    NSLog(@"infiniteScrollViewDidScrollToRawIndex: %.2f", index);
}

@end
