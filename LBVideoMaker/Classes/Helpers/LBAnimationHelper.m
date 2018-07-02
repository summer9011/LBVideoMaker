//
//  LBAnimationHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import "LBAnimationHelper.h"

@implementation LBAnimationHelper

+ (CAAnimation *)animationWithObject:(LBAnimationHelperObject *)object {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:object.keyPath];
    if (object.path) {
        animation.path = object.path.CGPath;
    } else {
        animation.values = object.values;
    }
    
    CFTimeInterval beginTime = object.beginTime;
    if (beginTime <= 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    animation.beginTime = beginTime;
    
    animation.duration = object.duration/((CGFloat)object.repeatCount * (object.autoreverses?2:1));
    animation.repeatCount = object.repeatCount;
    animation.autoreverses = object.autoreverses;
    animation.keyTimes = object.keyTimes;
    
    if (object.timingFunctions) {
        animation.timingFunctions = object.timingFunctions;
    }
    
    if (object.backwards && object.forwords) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBoth;
    } else if (object.backwards) {
        animation.fillMode = kCAFillModeBackwards;
    } else if (object.forwords) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
    
    return animation;
}

@end
