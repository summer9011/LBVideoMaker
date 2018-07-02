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
    
    LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithBehavior:behavior];
    NSMutableArray *cgImages = [NSMutableArray array];
    [behavior.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cgImages addObject:(id)obj.CGImage];
    }];
    animationObj.values = cgImages;
    animationObj.keyPath = @"contents";
    animationObj.beginTime = beginTime;
    animationObj.duration = duration;
    CAAnimation *animation = [LBAnimationHelper animationWithObject:animationObj];
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
        LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithBehavior:behavior];
        animationObj.path = behavior.path;
        animationObj.keyPath = @"position";
        animationObj.beginTime = beginTime;
        animationObj.duration = duration;
        animation = [LBAnimationHelper animationWithObject:animationObj];
    } else if (behavior.positions) {
        LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithBehavior:behavior];
        animationObj.values = behavior.positions;
        animationObj.keyPath = @"position";
        animationObj.beginTime = beginTime;
        animationObj.duration = duration;
        animation = [LBAnimationHelper animationWithObject:animationObj];
    }
    
    if (animation) {
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
    
    LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithBehavior:behavior];
    animationObj.values = behavior.zooms;
    animationObj.keyPath = @"bounds";
    animationObj.beginTime = beginTime;
    animationObj.duration = duration;
    CAAnimation *animation = [LBAnimationHelper animationWithObject:animationObj];
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
    
    LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithBehavior:behavior];
    animationObj.values = behavior.transforms;
    animationObj.keyPath = behavior.keyPath;
    animationObj.beginTime = beginTime;
    animationObj.duration = duration;
    CAAnimation *animation = [LBAnimationHelper animationWithObject:animationObj];
    [personLayer addAnimation:animation forKey:nil];
}

@end
