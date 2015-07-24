//
//  ViewController.m
//  BTArduinoImageScroll
//
//  Created by Chris Milne on 7/23/15.
//  Copyright (c) 2015 ideo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    [imageView2 setFrame:CGRectMake(imageView.frame.size.width, 0, imageView2.frame.size.width, imageView2.frame.size.height)];
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:imageView2];
    
    [self.scrollView setContentSize:CGSizeMake(imageView.frame.size.width*2, self.scrollView.frame.size.height)];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender {
    //NSLog(@"scrollViewDidScroll");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Here is where we let the system know that we can switch the lights using BT
}

@end
