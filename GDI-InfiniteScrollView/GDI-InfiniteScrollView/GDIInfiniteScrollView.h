//
//  GDIInfiniteScrollView.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic) NSUInteger currentIndex;

- (id)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers;

@property (strong, nonatomic) NSMutableArray *viewControllers;

@end