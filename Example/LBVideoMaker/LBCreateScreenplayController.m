//
//  LBCreateScreenplayController.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCreateScreenplayController.h"
#import "LBCreateTimelineController.h"

@interface LBCreateScreenplayController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarBtnItem;

@end

@implementation LBCreateScreenplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextBarBtnItem.enabled = NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LBCreateTimelineController *timelineVC = (LBCreateTimelineController *)segue.destinationViewController;
}

@end
