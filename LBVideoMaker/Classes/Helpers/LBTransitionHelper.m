//
//  LBTransitionHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import "LBTransitionHelper.h"
#import "LBAnimationHelper.h"
#import "LBImageHelper.h"
#import "LBTransitionObj.h"

@implementation LBTransitionHelper

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction isAppear:(BOOL)isAppear {
    if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        id<LBAlphaTransitionProtocol> alphaTransition = (id<LBAlphaTransitionProtocol>)transition;
        [layerInstruction setOpacityRampFromStartOpacity:alphaTransition.fromAlpha toEndOpacity:alphaTransition.toAlpha timeRange:CMTimeRangeMake(alphaTransition.absoluteStartTime, alphaTransition.timeRange.duration)];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition toAudioMixInputParameters:(AVMutableAudioMixInputParameters *)audioMixInputParameters {
    if ([transition conformsToProtocol:@protocol(LBVolumeTransitionProtocol)]) {
        id<LBVolumeTransitionProtocol> volumeTransition = (id<LBVolumeTransitionProtocol>)transition;
        [audioMixInputParameters setVolumeRampFromStartVolume:volumeTransition.fromVolume toEndVolume:volumeTransition.toVolume timeRange:CMTimeRangeMake(volumeTransition.absoluteStartTime, volumeTransition.timeRange.duration)];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition
     keepDurationTime:(CMTime)keepDurationTime
            withLayer:(CALayer *)layer
        toParentLayer:(CALayer *)parentLayer
             isAppear:(BOOL)isAppear {
    if (transition.animationBlock) {
        [self addDefaultTransitionInHost:transition.host
                        keepDurationTime:keepDurationTime
                               withLayer:layer
                           toParentLayer:parentLayer
                         withVideoFrames:keepDurationTime.timescale
                                isAppear:isAppear];
        transition.animationBlock(layer, parentLayer, CMTimeGetSeconds(keepDurationTime));
    } else {
        if ([transition conformsToProtocol:@protocol(LBColorMaskTransitionProtocol)]) {
            [self addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
                        keepDurationTime:keepDurationTime
                               withLayer:layer
                           toParentLayer:parentLayer
                                isAppear:isAppear];
        } else if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
            [self addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
                    keepDurationTime:keepDurationTime
                           withLayer:layer
                            isAppear:isAppear];
        } else if ([transition conformsToProtocol:@protocol(LBContentsMaskTransitionProtocol)]) {
            [self addContentsMaskTransition:(id<LBContentsMaskTransitionProtocol>)transition
                           keepDurationTime:keepDurationTime
                                  withLayer:layer
                              toParentLayer:parentLayer
                                   isAppear:isAppear];
        }
    }
}

+ (void)addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
              keepDurationTime:(CMTime)keepDurationTime
                     withLayer:(CALayer *)layer
                 toParentLayer:(CALayer *)parentLayer
                      isAppear:(BOOL)isAppear {
    BOOL isFromColorNull = (transition.fromColor == nil || [transition.fromColor isEqual:[UIColor clearColor]]);
    BOOL isToColorNull = (transition.toColor == nil || [transition.toColor isEqual:[UIColor clearColor]]);
    
    BOOL isContentChange = !isFromColorNull && !isToColorNull;
    BOOL isDefaultChange = isFromColorNull && isToColorNull;
    BOOL isAlphaChange = !isContentChange && !isDefaultChange;
    
    CFTimeInterval beginTime = CMTimeGetSeconds(transition.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    
    CALayer *colorMaskLayer = nil;
    CAAnimation *animation = nil;
    if (isContentChange) {
        colorMaskLayer = [CALayer layer];
        colorMaskLayer.frame = layer.frame;
        colorMaskLayer.opacity = 1.f;
        [parentLayer addSublayer:colorMaskLayer];
        
        UIImage *fromImage = [LBImageHelper createImageWithColor:transition.fromColor];
        UIImage *toImage = [LBImageHelper createImageWithColor:transition.toColor];
        
        LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithTransition:transition];
        animationObj.values = @[(id)fromImage.CGImage, (id)toImage.CGImage];
        animationObj.keyPath = @"contents";
        animationObj.beginTime = beginTime;
        animationObj.duration = duration;
        animation = [LBAnimationHelper animationWithObject:animationObj];
    } else if (isAlphaChange) {
        colorMaskLayer = [CALayer layer];
        colorMaskLayer.frame = layer.frame;
        colorMaskLayer.backgroundColor = isFromColorNull?transition.toColor.CGColor:transition.fromColor.CGColor;
        colorMaskLayer.opacity = 0.f;
        [parentLayer addSublayer:colorMaskLayer];
        
        CGFloat fromOpacity = isFromColorNull?0:1;
        CGFloat toOpacity = isFromColorNull?1:0;
        
        LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithTransition:transition];
        animationObj.values = @[@(fromOpacity), @(toOpacity)];
        animationObj.keyPath = @"opacity";
        animationObj.beginTime = beginTime;
        animationObj.duration = duration;
        animation = [LBAnimationHelper animationWithObject:animationObj];
    }
    
    if (colorMaskLayer) {
        [colorMaskLayer addAnimation:animation forKey:nil];
        
        LBDefaultTransitionObj *alphaTransitionObj = [[LBDefaultTransitionObj alloc] initWithFromAlpha:isAppear?0:1
                                                                                               toAlpha:isAppear?1:0
                                                                                                  host:transition.host
                                                                                             timeRange:transition.timeRange];
        [self addAlphaTransition:alphaTransitionObj
                keepDurationTime:keepDurationTime
                       withLayer:layer
                        isAppear:isAppear];
    }
}

+ (void)addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
          keepDurationTime:(CMTime)keepDurationTime
                 withLayer:(CALayer *)layer
                  isAppear:(BOOL)isAppear {
    CFTimeInterval beginTime = CMTimeGetSeconds(transition.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    
    LBAnimationHelperObject *transitionAnimationObj = [[LBAnimationHelperObject alloc] initWithTransition:transition];
    transitionAnimationObj.values = @[@(transition.fromAlpha), @(transition.toAlpha)];
    transitionAnimationObj.keyPath = @"opacity";
    transitionAnimationObj.beginTime = beginTime;
    transitionAnimationObj.duration = duration;
    CAAnimation *transitionAnimation = [LBAnimationHelper animationWithObject:transitionAnimationObj];
    [layer addAnimation:transitionAnimation forKey:nil];
    
    beginTime = CMTimeGetSeconds(CMTimeAdd(transition.absoluteStartTime, transition.timeRange.duration));
    if (isAppear) {
        duration = CMTimeGetSeconds(CMTimeSubtract(keepDurationTime, transition.timeRange.duration));
    } else {
        duration = CMTimeGetSeconds(keepDurationTime);
    }
    LBAnimationHelperObject *keepAnimationObj = [[LBAnimationHelperObject alloc] initWithTransition:transition];
    keepAnimationObj.values = @[@(transition.toAlpha), @(transition.toAlpha)];
    keepAnimationObj.keyPath = @"opacity";
    keepAnimationObj.beginTime = beginTime;
    keepAnimationObj.duration = duration;
    CAAnimation *keepAnimation = [LBAnimationHelper animationWithObject:keepAnimationObj];
    [layer addAnimation:keepAnimation forKey:nil];
}

+ (void)addContentsMaskTransition:(id<LBContentsMaskTransitionProtocol>)transition
                 keepDurationTime:(CMTime)keepDurationTime
                        withLayer:(CALayer *)layer
                    toParentLayer:(CALayer *)parentLayer
                         isAppear:(BOOL)isAppear {
    CFTimeInterval beginTime = CMTimeGetSeconds(transition.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    
    LBAnimationHelperObject *animationObj = [[LBAnimationHelperObject alloc] initWithTransition:transition];
    animationObj.values = @[(id)transition.fromImage.CGImage, (id)transition.toImage.CGImage];
    animationObj.keyPath = @"contents";
    animationObj.beginTime = beginTime;
    animationObj.duration = duration;
    CAAnimation *animation = [LBAnimationHelper animationWithObject:animationObj];
    [layer addAnimation:animation forKey:nil];
}

+ (void)addDefaultTransitionInHost:(id<LBTimeProtocol>)host
                  keepDurationTime:(CMTime)keepDurationTime
                         withLayer:(CALayer *)layer
                     toParentLayer:(CALayer *)parentLayer
                   withVideoFrames:(int32_t)videoFrames
                          isAppear:(BOOL)isAppear {
    CMTime durationTime = CMTimeMake(0.2, videoFrames);
    LBDefaultTransitionObj *defaultTransition = [LBDefaultTransitionObj new];
    if (isAppear) {
        defaultTransition = [[LBDefaultTransitionObj alloc] initWithFromAlpha:0
                                                                      toAlpha:1
                                                                         host:host
                                                                    timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    } else {
        defaultTransition = [[LBDefaultTransitionObj alloc] initWithFromAlpha:1
                                                                      toAlpha:0
                                                                         host:host
                                                                    timeRange:CMTimeRangeMake(CMTimeSubtract(host.timeRange.duration, durationTime), durationTime)];
    }
    [self addTransition:defaultTransition
       keepDurationTime:keepDurationTime
              withLayer:layer
          toParentLayer:parentLayer
               isAppear:isAppear];
}

@end
