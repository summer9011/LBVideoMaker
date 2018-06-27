//
//  LBBehaviorHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/25.
//

#import "LBBehaviorHelper.h"
#import "LBAnimationHelper.h"

@implementation LBBehaviorHelper

+ (void)addBehavior:(id<LBBehaviorProtocol>)behavior
    withPersonLayer:(CALayer *)personLayer
       toSceneLayer:(CALayer *)sceneLayer {
    if ([behavior conformsToProtocol:@protocol(LBContentsGradientBehaviorProtocol)]) {
        [self addContentsGradientBehavior:(id<LBContentsGradientBehaviorProtocol>)behavior
                          withPersonLayer:personLayer
                             toSceneLayer:sceneLayer];
    } else if ([behavior conformsToProtocol:@protocol(LBMovesBehaviorProtocol)]) {
        [self addMovesBehavior:(id<LBMovesBehaviorProtocol>)behavior
               withPersonLayer:personLayer
                  toSceneLayer:sceneLayer];
    }
}

+ (void)addContentsGradientBehavior:(id<LBContentsGradientBehaviorProtocol>)behavior
                    withPersonLayer:(CALayer *)personLayer
                       toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteUsableTimeRange.start);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.absoluteUsableTimeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper contentsAnimationWithImages:behavior.images
                                                                  beginTime:beginTime
                                                                   duration:duration
                                                                repeatCount:behavior.repeatCount
                                                        timingFunctionNames:nil];
    [personLayer addAnimation:animation forKey:nil];
}

+ (void)addMovesBehavior:(id<LBMovesBehaviorProtocol>)behavior
         withPersonLayer:(CALayer *)personLayer
            toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteUsableTimeRange.start);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.absoluteUsableTimeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper positionAnimationWithPositions:behavior.positions
                                                                     beginTime:beginTime
                                                                      duration:duration
                                                                   repeatCount:behavior.repeatCount
                                                           timingFunctionNames:behavior.timingFunctionNames];
    [personLayer addAnimation:animation forKey:nil];
}

@end
