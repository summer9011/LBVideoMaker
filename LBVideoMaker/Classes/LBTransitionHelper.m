//
//  LBTransitionHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import "LBTransitionHelper.h"
#import "LBAnimationHelper.h"

@implementation LBTransitionHelper

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction {
    if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        id<LBAlphaTransitionProtocol> alphaTransition = (id<LBAlphaTransitionProtocol>)transition;
        [layerInstruction setOpacityRampFromStartOpacity:alphaTransition.fromAlpha toEndOpacity:alphaTransition.toAlpha timeRange:alphaTransition.timeRange];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition toAudioMixInputParameters:(AVMutableAudioMixInputParameters *)audioMixInputParameters {
    if ([transition conformsToProtocol:@protocol(LBVolumeTransitionProtocol)]) {
        id<LBVolumeTransitionProtocol> volumeTransition = (id<LBVolumeTransitionProtocol>)transition;
        [audioMixInputParameters setVolumeRampFromStartVolume:volumeTransition.fromVolume toEndVolume:volumeTransition.toVolume timeRange:volumeTransition.timeRange];
    }
}

+ (void)addTransition:(id<LBTransitionProtocol>)transition withLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer {
    if ([transition conformsToProtocol:@protocol(LBColorMaskTransitionProtocol)]) {
        
    } else if ([transition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
        
    }
}
+ (void)addDefaultAppearTransitionWithLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer {
    
}
+ (void)addDefaultDisappearTransitionWithLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer {
    
}

@end
