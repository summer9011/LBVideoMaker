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
                                        duration:(CFTimeInterval)duration
                                     repeatCount:(NSUInteger)repeatCount
                                    autoreverses:(BOOL)autoreverses
                              timingFunctionName:(NSString *)timingFunctionName {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(fromOpacity);
    animation.toValue = @(toOpacity);
    animation.beginTime = beginTime;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    if (timingFunctionName) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    }
    return animation;
}

+ (CAAnimation *)positionAnimationWithPositions:(NSArray<NSValue *> *)positions
                                      beginTime:(CFTimeInterval)beginTime
                                       duration:(CFTimeInterval)duration
                                    repeatCount:(NSUInteger)repeatCount
                                   autoreverses:(BOOL)autoreverses
                            timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames {
    NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray array];
    [positions enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [keyTimes addObject:@0];
        } else {
            [keyTimes addObject:@(idx/(CGFloat)(positions.count - 1))];
        }
    }];
    
    NSMutableArray<CAMediaTimingFunction *> *timingFunctions = nil;
    if (timingFunctionNames) {
        [timingFunctionNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:obj];
            [timingFunctions addObject:timingFunction];
        }];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = positions;
    animation.beginTime = beginTime;
    animation.duration = duration/((CGFloat)repeatCount * (autoreverses?2:1));
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    animation.keyTimes = keyTimes;
    if (timingFunctions) {
        animation.timingFunctions = timingFunctions;
    }
    
    return animation;
}

+ (CAAnimation *)pathAnimationWithPath:(UIBezierPath *)path
                             beginTime:(CFTimeInterval)beginTime
                              duration:(CFTimeInterval)duration
                           repeatCount:(NSUInteger)repeatCount
                          autoreverses:(BOOL)autoreverses
                   timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.beginTime = beginTime;
    animation.duration = duration/((CGFloat)repeatCount * (autoreverses?2:1));
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    if (timingFunctionNames) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionNames.firstObject];
    }
    
    return animation;
}

+ (CAAnimation *)boundsAnimationWithZooms:(NSArray<NSValue *> *)zooms
                                beginTime:(CFTimeInterval)beginTime
                                 duration:(CFTimeInterval)duration
                              repeatCount:(NSUInteger)repeatCount
                             autoreverses:(BOOL)autoreverses
                      timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames {
    NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray array];
    [zooms enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [keyTimes addObject:@0];
        } else {
            [keyTimes addObject:@(idx/(CGFloat)(zooms.count - 1))];
        }
    }];
    
    NSMutableArray<CAMediaTimingFunction *> *timingFunctions = nil;
    if (timingFunctionNames) {
        [timingFunctionNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:obj];
            [timingFunctions addObject:timingFunction];
        }];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = zooms;
    animation.beginTime = beginTime;
    animation.duration = duration/((CGFloat)repeatCount * (autoreverses?2:1));
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    animation.keyTimes = keyTimes;
    if (timingFunctions) {
        animation.timingFunctions = timingFunctions;
    }
    
    return animation;
}

+ (CAAnimation *)transformAnimationWithKeyPath:(NSString *)keyPath
                                    transforms:(NSArray<NSValue *> *)transforms
                                     beginTime:(CFTimeInterval)beginTime
                                      duration:(CFTimeInterval)duration
                                   repeatCount:(NSUInteger)repeatCount
                                  autoreverses:(BOOL)autoreverses
                           timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames {
    NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray array];
    [transforms enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [keyTimes addObject:@0];
        } else {
            [keyTimes addObject:@(idx/(CGFloat)(transforms.count - 1))];
        }
    }];
    
    NSMutableArray<CAMediaTimingFunction *> *timingFunctions = nil;
    if (timingFunctionNames) {
        [timingFunctionNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:obj];
            [timingFunctions addObject:timingFunction];
        }];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = transforms;
    animation.beginTime = beginTime;
    animation.duration = duration/((CGFloat)repeatCount * (autoreverses?2:1));
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    animation.keyTimes = keyTimes;
    if (timingFunctions) {
        animation.timingFunctions = timingFunctions;
    }
    
    return animation;
}

+ (CAAnimation *)contentAnimationWithFromImage:(UIImage *)fromImage
                                       toImage:(UIImage *)toImage
                                     beginTime:(CFTimeInterval)beginTime
                                      duration:(CFTimeInterval)duration
                                   repeatCount:(NSUInteger)repeatCount
                                  autoreverses:(BOOL)autoreverses
                            timingFunctionName:(NSString *)timingFunctionName {
    return [self contentsAnimationWithImages:@[fromImage, toImage]
                                   beginTime:beginTime
                                    duration:duration
                                 repeatCount:1
                                autoreverses:NO
                         timingFunctionNames:((timingFunctionName != nil)?@[timingFunctionName]:nil)];
}

+ (CAAnimation *)contentsAnimationWithImages:(NSArray<UIImage *> *)images
                                   beginTime:(CFTimeInterval)beginTime
                                    duration:(CFTimeInterval)duration
                                 repeatCount:(NSUInteger)repeatCount
                                autoreverses:(BOOL)autoreverses
                         timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames {
    NSMutableArray *cgImages = [NSMutableArray array];
    NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cgImages addObject:(id)obj.CGImage];
        if (idx == 0) {
            [keyTimes addObject:@0];
        } else {
            [keyTimes addObject:@(idx/(CGFloat)(images.count - 1))];
        }
    }];
    
    NSMutableArray<CAMediaTimingFunction *> *timingFunctions = nil;
    if (timingFunctionNames) {
        [timingFunctionNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:obj];
            [timingFunctions addObject:timingFunction];
        }];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = cgImages;
    animation.beginTime = beginTime;
    animation.duration = duration/((CGFloat)repeatCount * (autoreverses?2:1));
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    animation.keyTimes = keyTimes;
    if (timingFunctions) {
        animation.timingFunctions = timingFunctions;
    }
    return animation;
}

@end
