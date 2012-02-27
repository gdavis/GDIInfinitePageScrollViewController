//
//  DemoViewController.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentViewController.h"

@implementation DemoViewController
@synthesize infiniteScrollView;

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
    
    [pageOneVC view];
    [pageTwoVC view];
    [pageThreeVC view];
    [pageFourVC view];
    [pageFiveVC view];
    
    pageOneVC.viewLabel.text = @"0";
    pageTwoVC.viewLabel.text = @"1";
    pageThreeVC.viewLabel.text = @"2";
    pageFourVC.viewLabel.text = @"3";
    pageFiveVC.viewLabel.text = @"4";
    
    self.infiniteScrollView.viewControllers = [NSMutableArray arrayWithObjects:pageOneVC, pageTwoVC, pageThreeVC, pageFourVC, pageFiveVC, nil];
}

- (void)viewDidUnload
{
    [self setInfiniteScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSUInteger)numberOfPagesForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView
{
    return 10;
}

- (NSUInteger)maxNumberOfViewablePagesForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView
{
    return 3;
}

- (UIView *)viewForInfiniteScrollView:(GDIInfiniteScrollView *)scrollView atIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = [NSString stringWithFormat:@"view %i", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.layer.borderColor = [[UIColor redColor] CGColor];
    label.layer.borderWidth = 1.f;
    return label;
}

@end
