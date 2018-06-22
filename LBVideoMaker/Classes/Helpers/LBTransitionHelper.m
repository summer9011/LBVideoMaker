//
//  LBTransitionHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import "LBTransitionHelper.h"
#import "LBAnimationHelper.h"
#import "LBImageHelper.h"
#import "LBDefaultTransitionObj.h"

@implementation LBTransitionHelper

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction atStartTime:(CMTime)startTime {
    if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        id<LBAlphaTransitionProtocol> alphaTransition = (id<LBAlphaTransitionProtocol>)transition;
        [layerInstruction setOpacityRampFromStartOpacity:alphaTransition.fromAlpha toEndOpacity:alphaTransition.toAlpha timeRange:CMTimeRangeMake(CMTimeAdd(startTime, alphaTransition.timeRange.start), alphaTransition.timeRange.duration)];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition toAudioMixInputParameters:(AVMutableAudioMixInputParameters *)audioMixInputParameters atStartTime:(CMTime)startTime {
    if ([transition conformsToProtocol:@protocol(LBVolumeTransitionProtocol)]) {
        id<LBVolumeTransitionProtocol> volumeTransition = (id<LBVolumeTransitionProtocol>)transition;
        [audioMixInputParameters setVolumeRampFromStartVolume:volumeTransition.fromVolume toEndVolume:volumeTransition.toVolume timeRange:CMTimeRangeMake(CMTimeAdd(startTime, volumeTransition.timeRange.start), volumeTransition.timeRange.duration)];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition
          atStartTime:(CMTime)startTime
     keepDurationTime:(CMTime)keepDurationTime
            withLayer:(CALayer *)layer
        toParentLayer:(CALayer *)parentLayer {
    if ([transition conformsToProtocol:@protocol(LBColorMaskTransitionProtocol)]) {
        [self addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
                         atStartTime:startTime
                    keepDurationTime:keepDurationTime
                           withLayer:layer
                       toParentLayer:parentLayer];
    } else if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        [self addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
                     atStartTime:startTime
                keepDurationTime:keepDurationTime
                       withLayer:layer];
    }
}

+ (void)addColorMaskTransition:(id<LBColorMaskTransitionProtocol>)transition
                   atStartTime:(CMTime)startTime
              keepDurationTime:(CMTime)keepDurationTime
                     withLayer:(CALayer *)layer
               toParentLayer:(CALayer *)parentLayer {
    BOOL isFromColorNull = (transition.fromColor == nil || [transition.fromColor isEqual:[UIColor clearColor]]);
    BOOL isToColorNull = (transition.toColor == nil || [transition.toColor isEqual:[UIColor clearColor]]);
    
    BOOL isContentChange = !isFromColorNull && !isToColorNull;
    BOOL isDefaultChange = isFromColorNull && isToColorNull;
    BOOL isAlphaChange = !isContentChange && !isDefaultChange;
    
    CFTimeInterval beginTime = CMTimeGetSeconds(CMTimeAdd(startTime, transition.timeRange.start));
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
                                                            duration:duration];
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
                                                              duration:duration];
    }
    if (colorMaskLayer) {
        [colorMaskLayer addAnimation:animation forKey:nil];
        
        LBDefaultTransitionObj *alphaTransitionObj = [LBDefaultTransitionObj new];
        alphaTransitionObj.fromAlpha = transition.isAppear?0:1;
        alphaTransitionObj.toAlpha = transition.isAppear?1:0;
        alphaTransitionObj.timeRange = transition.timeRange;
        [self addAlphaTransition:alphaTransitionObj
                     atStartTime:startTime
                keepDurationTime:keepDurationTime
                       withLayer:layer];
    }
}

+ (void)addAlphaTransition:(id<LBAlphaTransitionProtocol>)transition
               atStartTime:(CMTime)startTime
          keepDurationTime:(CMTime)keepDurationTime
                 withLayer:(CALayer *)layer {
    CMTime beginCMTime = CMTimeAdd(startTime, transition.timeRange.start);
    
    CFTimeInterval beginTime = CMTimeGetSeconds(beginCMTime);
    CFTimeInterval duration = CMTimeGetSeconds(transition.timeRange.duration);
    CAAnimation *transitionAnimation = [LBAnimationHelper opacityAnimationWithFromOpacity:transition.fromAlpha
                                                                                toOpacity:transition.toAlpha
                                                                                beginTime:beginTime
                                                                                 duration:duration];
    
    beginTime = CMTimeGetSeconds(CMTimeAdd(beginCMTime, transition.timeRange.duration));
    duration = CMTimeGetSeconds(CMTimeSubtract(keepDurationTime, transition.timeRange.duration));
    CAAnimation *keepAnimation = [LBAnimationHelper opacityAnimationWithFromOpacity:transition.toAlpha
                                                                          toOpacity:transition.toAlpha
                                                                          beginTime:beginTime
                                                                           duration:duration];
    
    [layer addAnimation:transitionAnimation forKey:nil];
    [layer addAnimation:keepAnimation forKey:nil];
}

+ (void)addDefaultTransitionInTimeRange:(CMTimeRange)timeRange
                       keepDurationTime:(CMTime)keepDurationTime
                              withLayer:(CALayer *)layer
                          toParentLayer:(CALayer *)parentLayer
                        withVideoFrames:(int32_t)videoFrames
                               isAppear:(BOOL)isAppear {
    CMTime durationTime = CMTimeMake(0.2, videoFrames);
    LBDefaultTransitionObj *defaultTransition = [LBDefaultTransitionObj new];
    if (isAppear) {
        defaultTransition.fromAlpha = 0;
        defaultTransition.toAlpha = 1;
        defaultTransition.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    } else {
        defaultTransition.fromAlpha = 1;
        defaultTransition.toAlpha = 0;
        defaultTransition.timeRange = CMTimeRangeMake(CMTimeSubtract(timeRange.duration, durationTime), durationTime);
    }
    [self addTransition:defaultTransition
            atStartTime:timeRange.start
       keepDurationTime:keepDurationTime
              withLayer:layer
          toParentLayer:parentLayer];
}

@end