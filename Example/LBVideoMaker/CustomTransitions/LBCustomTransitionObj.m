//
//  LBCustomTransitionObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/29.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCustomTransitionObj.h"

@implementation LBCustomTransitionObj

@synthesize timeRange;
@synthesize absoluteStartTime;
@synthesize fromValue;
@synthesize toValue;
@synthesize host;
@synthesize animationBlock;

+ (LBCustomTransitionObj *)transitionWithBlock:(void(^)(CALayer *layer, CALayer *parentLayer, CFTimeInterval keepTime))block {
    LBCustomTransitionObj *transition = [LBCustomTransitionObj new];
    transition.animationBlock = block;
    return transition;
}

@end
