//
//  LBAnimationHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import "LBAnimationHelper.h"

@implementation LBAnimationHelper

+ (CAAnimation *)opacityAnimationWithFromOpacity:(CGFloat)fromOpacity
                                       toOpacity:(CGFloat)toOpacity
                                       beginTime:(CFTimeInterval)beginTime
                                        duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(fromOpacity);
    animation.toValue = @(toOpacity);
    animation.beginTime = beginTime;
    animation.duration = duration;
    return animation;
}

+ (CAAnimation *)contentAnimationWithFromImage:(UIImage *)fromImage
                                       toImage:(UIImage *)toImage
                                     beginTime:(CFTimeInterval)beginTime
                                      duration:(CFTimeInterval)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = @[(id)fromImage.CGImage, (id)toImage.CGImage];
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.keyTimes = @[@0, @1];
    return animation;
}

@end
