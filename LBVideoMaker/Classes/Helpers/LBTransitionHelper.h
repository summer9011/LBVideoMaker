//
//  LBTransitionHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import <Foundation/Foundation.h>
#import "LBTransitionProtocol.h"

@import AVFoundation;

@interface LBTransitionHelper : NSObject

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction;

+ (void)addTransition:(id<LBTransitionProtocol>)transition toAudioMixInputParameters:(AVMutableAudioMixInputParameters *)audioMixInputParameters;

+ (void)addTransition:(id<LBTransitionProtocol>)transition
     keepDurationTime:(CMTime)keepDurationTime
            withLayer:(CALayer *)layer
        toParentLayer:(CALayer *)parentLayer;

+ (void)addDefaultTransitionInContenter:(id<LBTimeProtocol>)contenter
                       keepDurationTime:(CMTime)keepDurationTime
                              withLayer:(CALayer *)layer
                          toParentLayer:(CALayer *)parentLayer
                        withVideoFrames:(int32_t)videoFrames
                               isAppear:(BOOL)isAppear;

@end
