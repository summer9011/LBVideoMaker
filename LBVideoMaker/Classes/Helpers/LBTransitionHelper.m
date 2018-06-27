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

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction {
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
        toParentLayer:(CALayer *)parentLayer {
    if ([transition conformsToProtocol:@protocol(LBColorMaskTransitionProtocol)]) {
        [self addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
                    keepDurationTime:keepDurationTime
                           withLayer:layer
                       toParentLayer:parentLayer];
    } else if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        [self addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
                keepDurationTime:keepDurationTime
                       withLayer:layer];
    } else if ([transition conformsToProtocol:@protocol(LBContentsMaskTransitionProtocol)]) {
        [self addContentsMaskTransition:(id<LBContentsMaskTransitionProtocol>)transition
                       keepDurationTime:keepDurationTime
                              withLayer:layer
                          toParentLayer:parentLayer];
    }
}

+ (void)addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
              keepDurationTime:(CMTime)keepDurationTime
                     withLayer:(CALayer *)layer
               toParentLayer:(CALayer *)parentLayer {
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
        
        animation = [LBAnimationHelper contentAnimationWithFromImage:fromImage
                                                             toImage:toImage
                                                           beginTime:beginTime
                                                            duration:duration
                                                  timingFunctionName:nil];
    } else if (isAlphaChange) {
        colorMaskLayer = [CALayer layer];
        colorMaskLayer.frame = layer.frame;
        colorMaskLayer.backgroundColor = isFromColorNull?transition.toColor.CGColor:transition.fromColor.CGColor;
        colorMaskLayer.opacity = 0.f;
        [parentLayer addSublayer:colorMaskLayer];
        
        CGFloat fromOpacity = isFromColorNull?0:1;
        CGFloat toOpacity = isFromColorNull?1:0;
        
        animation = [LBAnimationHelper opacityAnimationWithFromOpacity:fromOpacity
                                                             toOpacity:toOpacity
                                                             beginTime:beginTime
                                                              duration:duration
                                                    timingFunctionName:nil];
    }
    if (colorMaskLayer) {
        [colorMaskLayer addAnimation:animation forKey:nil];
        
        LBDefaultTransitionObj *alphaTransitionObj = [[LBDefaultTransitionObj alloc] initWithFromAlpha:transition.isAppear?0:1
                                                                                               toAlpha:transition.isAppear?1:0
                                                                                                  host:transition.host
                                                                                             timeRange:transition.timeRange];
        [self addAlphaTransition:alphaTransitionObj
                keepDurationTime:keepDurationTime
                       withLayer:layer];
    }
}

+ (void)addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
          keepDurationTime:(CMTime)keepDurationTime
                 withLayer:(CALayer *)layer {
    CFTimeInterval beginTime = CMTimeGetSeconds(transition.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    CAAnimation *transitionAnimation = [LBAnimationHelper opacityAnimationWithFromOpacity:transition.fromAlpha
                                                                                toOpacity:transition.toAlpha
                                                                                beginTime:beginTime
                                                                                 duration:duration
                                                                       timingFunctionName:nil];
    
    beginTime = CMTimeGetSeconds(CMTimeAdd(transition.absoluteStartTime, transition.timeRange.duration));
    duration = CMTimeGetSeconds(CMTimeSubtract(keepDurationTime, transition.timeRange.duration));
    CAAnimation *keepAnimation = [LBAnimationHelper opacityAnimationWithFromOpacity:transition.toAlpha
                                                                          toOpacity:transition.toAlpha
                                                                          beginTime:beginTime
                                                                           duration:duration
                                                                 timingFunctionName:nil];
    keepAnimation.removedOnCompletion = NO;
    keepAnimation.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:transitionAnimation forKey:nil];
    [layer addAnimation:keepAnimation forKey:nil];
}

+ (void)addContentsMaskTransition:(id<LBContentsMaskTransitionProtocol>)transition
                 keepDurationTime:(CMTime)keepDurationTime
                        withLayer:(CALayer *)layer
                    toParentLayer:(CALayer *)parentLayer {
    CFTimeInterval beginTime = CMTimeGetSeconds(transition.absoluteStartTime);
    if (beginTime == 0.f) {
        beginTime = AVCoreAnimationBeginTimeAtZero;
    }
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    
    CAAnimation *animation = [LBAnimationHelper contentAnimationWithFromImage:transition.fromImage
                                                                      toImage:transition.toImage
                                                                    beginTime:beginTime
                                                                     duration:duration
                                                           timingFunctionName:nil];
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
          toParentLayer:parentLayer];
}

@end
