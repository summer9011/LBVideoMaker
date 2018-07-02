//
//  LBCreateTimelineController.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCreateTimelineController.h"
#import "LBResourceListController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface LBCreateTimelineController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarBtnItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation LBCreateTimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 500, [UIScreen mainScreen].bounds.size.height + 500);
    
    [RACObserve(self, isScrolling) subscribeNext:^(id  _Nullable x) {
        NSLog(@"isScrolling %d", [x boolValue]);
    }];
}

#pragma mark - Actions

- (IBAction)doDoneAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *naviVC = (UINavigationController *)segue.destinationViewController;
    LBResourceListController *resouceListVC = (LBResourceListController *)naviVC.viewControllers.firstObject;
    resouceListVC.obj = self.obj;
}

@end
