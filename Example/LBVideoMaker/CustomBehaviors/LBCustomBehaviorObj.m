//
//  LBCustomBehaviorObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/28.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBCustomBehaviorObj.h"

@implementation LBCustomBehaviorObj

@synthesize timeRange;
@synthesize absoluteStartTime;
@synthesize repeatCount;
@synthesize autoreverses;
@synthesize timingFunctionNames;
@synthesize extendBackwards;
@synthesize extendForwards;
@synthesize nextBehavior;
@synthesize contentPerson;
@synthesize animationBlock;

+ (LBCustomBehaviorObj *)behaviorWithBlock:(void(^)(CALayer *personLayer, CALayer *sceneLayer))block {
    LBCustomBehaviorObj *behavior = [LBCustomBehaviorObj new];
    behavior.animationBlock = block;
    return behavior;
}

@end
