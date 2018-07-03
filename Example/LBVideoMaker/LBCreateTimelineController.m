//
//  LBCreateTimelineController.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCreateTimelineController.h"
#import "LBTimelineView.h"
#import "LBResourceListController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface LBCreateTimelineController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarBtnItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) LBPinTimelineView *beginPin;
@property (nonatomic, strong) LBPinTimelineView *endPin;

@end

@implementation LBCreateTimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 500, [UIScreen mainScreen].bounds.size.height + 500);
    
    [self.scrollView addSubview:self.beginPin];
}

#pragma mark - Actions

- (IBAction)doDoneAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture

- (void)panOnView:(UIPanGestureRecognizer *)pan {
    LBTimelineView *view = (LBTimelineView *)pan.view;
    
    CGPoint offset = [pan translationInView:view];
    CGPoint point = view.center;
    point.x += offset.x;
    view.center = point;
    [pan setTranslation:CGPointZero inView:view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSUInteger p = 10;
        
        CGFloat x = floorf(point.x/p);
        CGFloat leave = point.x - x*p;
        if (leave < p*0.5) {
            point.x = x*p;
        } else {
            point.x = (x+1)*p;
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            view.center = point;
        }];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *naviVC = (UINavigationController *)segue.destinationViewController;
    LBResourceListController *resouceListVC = (LBResourceListController *)naviVC.viewControllers.firstObject;
    resouceListVC.obj = self.obj;
}

#pragma mark - Getting

- (LBPinTimelineView *)beginPin {
    if (_beginPin == nil) {
        _beginPin = [LBPinTimelineView new];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
        [_beginPin addGestureRecognizer:pan];
    }
    return _beginPin;
}

- (LBPinTimelineView *)endPin {
    if (_endPin == nil) {
        _endPin = [LBPinTimelineView new];
    }
    return _endPin;
}

@end
