//
//  DemoViewController.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.infiniteScrollView.dataSource = self;
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
