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
    if (behavior.animationBlock) {
        behavior.animationBlock(personLayer, sceneLayer);
    } else {
        if ([behavior conformsToProtocol:@protocol(LBContentGradientBehaviorProtocol)]) {
            [self addContentsGradientBehavior:(id<LBContentGradientBehaviorProtocol>)behavior
                              withPersonLayer:personLayer
                                 toSceneLayer:sceneLayer];
        } else if ([behavior conformsToProtocol:@protocol(LBMoveBehaviorProtocol)]) {
            [self addMovesBehavior:(id<LBMoveBehaviorProtocol>)behavior
                   withPersonLayer:personLayer
                      toSceneLayer:sceneLayer];
        } else if ([behavior conformsToProtocol:@protocol(LBZoomBehaviorProtocol)]) {
            [self addZoomBehavior:(id<LBZoomBehaviorProtocol>)behavior
                  withPersonLayer:personLayer
                     toSceneLayer:sceneLayer];
        } else if ([behavior conformsToProtocol:@protocol(LBTransformBehaviorProtocol)]) {
            [self addTransformBehavior:(id<LBTransformBehaviorProtocol>)behavior
                       withPersonLayer:personLayer
                          toSceneLayer:sceneLayer];
        }
    }
}

+ (void)addContentsGradientBehavior:(id<LBContentGradientBehaviorProtocol>)behavior
                    withPersonLayer:(CALayer *)personLayer
                       toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.timeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper contentsAnimationWithImages:behavior.images
                                                                  beginTime:beginTime
                                                                   duration:duration
                                                                repeatCount:behavior.repeatCount
                                                               autoreverses:behavior.autoreverses
                                                        timingFunctionNames:behavior.timingFunctionNames];
    [self addCommonBehaviorProperty:behavior forAnimation:animation];
    [personLayer addAnimation:animation forKey:nil];
}

+ (void)addMovesBehavior:(id<LBMoveBehaviorProtocol>)behavior
         withPersonLayer:(CALayer *)personLayer
            toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.timeRange.duration);
    
    CAAnimation *animation = nil;
    if (behavior.path) {
        animation = [LBAnimationHelper pathAnimationWithPath:behavior.path
                                                   beginTime:beginTime
                                                    duration:duration
                                                 repeatCount:behavior.repeatCount
                                                autoreverses:behavior.autoreverses
                                         timingFunctionNames:behavior.timingFunctionNames];
    } else if (behavior.positions) {
        animation = [LBAnimationHelper positionAnimationWithPositions:behavior.positions
                                                            beginTime:beginTime
                                                             duration:duration
                                                          repeatCount:behavior.repeatCount
                                                         autoreverses:behavior.autoreverses
                                                  timingFunctionNames:behavior.timingFunctionNames];
    }
    
    if (animation) {
        [self addCommonBehaviorProperty:behavior forAnimation:animation];
        [personLayer addAnimation:animation forKey:nil];
    }
}

+ (void)addZoomBehavior:(id<LBZoomBehaviorProtocol>)behavior
        withPersonLayer:(CALayer *)personLayer
           toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.timeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper boundsAnimationWithZooms:behavior.zooms
                                                               beginTime:beginTime
                                                                duration:duration
                                                             repeatCount:behavior.repeatCount
                                                            autoreverses:behavior.autoreverses
                                                     timingFunctionNames:behavior.timingFunctionNames];
    [self addCommonBehaviorProperty:behavior forAnimation:animation];
    [personLayer addAnimation:animation forKey:nil];
}

+ (void)addTransformBehavior:(id<LBTransformBehaviorProtocol>)behavior
             withPersonLayer:(CALayer *)personLayer
                toSceneLayer:(CALayer *)sceneLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(behavior.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(behavior.timeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper transformAnimationWithKeyPath:behavior.keyPath
                                                                   transforms:behavior.transforms
                                                                    beginTime:beginTime
                                                                     duration:duration
                                                                  repeatCount:behavior.repeatCount
                                                                 autoreverses:behavior.autoreverses
                                                          timingFunctionNames:behavior.timingFunctionNames];
    [self addCommonBehaviorProperty:behavior forAnimation:animation];
    [personLayer addAnimation:animation forKey:nil];
}
    
+ (void)addCommonBehaviorProperty:(id<LBBehaviorProtocol>)behavior forAnimation:(CAAnimation *)animation {
    if (behavior.extendBackwards && behavior.extendForwards) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBoth;
    } else if (behavior.extendBackwards) {
        animation.fillMode = kCAFillModeBackwards;
    } else if (behavior.extendForwards) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
}

@end
