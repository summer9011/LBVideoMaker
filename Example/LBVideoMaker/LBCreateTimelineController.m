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

@interface LBCreateTimelineController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarBtnItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LBCreateTimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 500, [UIScreen mainScreen].bounds.size.height + 500);
    
    NSLog(@"%@", self.obj.description);
}

#pragma mark - Actions

- (IBAction)doDoneAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *naviVC = (UINavigationController *)segue.destinationViewController;
    LBResourceListController *resouceListVC = (LBResourceListController *)naviVC.viewControllers.firstObject;
    resouceListVC.obj = self.obj;
}

@end
