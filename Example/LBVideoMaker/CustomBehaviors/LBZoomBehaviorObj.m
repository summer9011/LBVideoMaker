//
//  LBZoomBehaviorObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/28.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBZoomBehaviorObj.h"

@implementation LBZoomBehaviorObj

@synthesize timeRange;
@synthesize absoluteStartTime;

@synthesize repeatCount;
@synthesize autoreverses;
@synthesize timingFunctionNames;

@synthesize extendBackwards;
@synthesize extendForwards;

@synthesize nextBehavior;
@synthesize contentPerson = _contentPerson;

@synthesize animationBlock;

+ (LBZoomBehaviorObj *)animationWithBlock:(void(^)(CALayer *personLayer, CALayer *sceneLayer))block {
    LBZoomBehaviorObj *behavior = [LBZoomBehaviorObj new];
    behavior.animationBlock = block;
    return behavior;
}

- (void)setContentPerson:(id<LBPersonProtocol>)contentPerson {
    _contentPerson = contentPerson;
}

@end
