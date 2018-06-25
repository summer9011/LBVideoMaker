//
//  LBVideoObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"
#import "LBVideoProtocol.h"

#import "LBBehaviorObj.h"
#import "LBPersonObj.h"
#import "LBSceneObj.h"
#import "LBTimeObj.h"
#import "LBEnvironmentObj.h"
#import "LBTransitionObj.h"

@interface LBVideoObj : LBBaseObj <LBVideoProtocol>

- (instancetype)initWithFramePerSecond:(int32_t)framePerSecond videoSize:(CGSize)videoSize;

@end
