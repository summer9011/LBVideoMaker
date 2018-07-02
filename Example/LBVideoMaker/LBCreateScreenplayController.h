//
//  LBCreateScreenplayController.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBCreateScreenplayController : UIViewController

@property (nonatomic, strong) void(^createBlock)(NSURL *screenplayURL);

@end
