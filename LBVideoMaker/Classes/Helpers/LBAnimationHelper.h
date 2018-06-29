//
//  LBAnimationHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import <Foundation/Foundation.h>

@interface LBAnimationHelper : NSObject

+ (CAAnimation *)opacityAnimationWithFromOpacity:(CGFloat)fromOpacity
                                       toOpacity:(CGFloat)toOpacity
                                       beginTime:(CFTimeInterval)beginTime
                                        duration:(CFTimeInterval)duration
                                     repeatCount:(NSUInteger)repeatCount
                                    autoreverses:(BOOL)autoreverses
                              timingFunctionName:(NSString *)timingFunctionName;

+ (CAAnimation *)positionAnimationWithPositions:(NSArray<NSValue *> *)positions
                                      beginTime:(CFTimeInterval)beginTime
                                       duration:(CFTimeInterval)duration
                                    repeatCount:(NSUInteger)repeatCount
                                   autoreverses:(BOOL)autoreverses
                            timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames;

+ (CAAnimation *)pathAnimationWithPath:(UIBezierPath *)path
                             beginTime:(CFTimeInterval)beginTime
                              duration:(CFTimeInterval)duration
                           repeatCount:(NSUInteger)repeatCount
                          autoreverses:(BOOL)autoreverses
                   timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames;

+ (CAAnimation *)boundsAnimationWithZooms:(NSArray<NSValue *> *)zooms
                                beginTime:(CFTimeInterval)beginTime
                                 duration:(CFTimeInterval)duration
                              repeatCount:(NSUInteger)repeatCount
                             autoreverses:(BOOL)autoreverses
                      timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames;

+ (CAAnimation *)transformAnimationWithKeyPath:(NSString *)keyPath
                                    transforms:(NSArray<NSValue *> *)transforms
                                     beginTime:(CFTimeInterval)beginTime
                                      duration:(CFTimeInterval)duration
                                   repeatCount:(NSUInteger)repeatCount
                                  autoreverses:(BOOL)autoreverses
                           timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames;

+ (CAAnimation *)contentAnimationWithFromImage:(UIImage *)fromImage
                                       toImage:(UIImage *)toImage
                                     beginTime:(CFTimeInterval)beginTime
                                      duration:(CFTimeInterval)duration
                                   repeatCount:(NSUInteger)repeatCount
                                  autoreverses:(BOOL)autoreverses
                            timingFunctionName:(NSString *)timingFunctionName;

+ (CAAnimation *)contentsAnimationWithImages:(NSArray<UIImage *> *)images
                                   beginTime:(CFTimeInterval)beginTime
                                    duration:(CFTimeInterval)duration
                                 repeatCount:(NSUInteger)repeatCount
                                autoreverses:(BOOL)autoreverses
                         timingFunctionNames:(NSArray<NSString *> *)timingFunctionNames;

@end
