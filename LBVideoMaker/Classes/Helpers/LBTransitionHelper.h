//
//  LBTransitionHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LBTransitionProtocol.h"

@interface LBTransitionHelper : NSObject

+ (void)addTransition:(id<LBTransitionProtocol>)transition toLayerInstruction:(AVMutableVideoCompositionLayerInstruction *)layerInstruction isAppear:(BOOL)isAppear;

+ (void)addTransition:(id<LBTransitionProtocol>)transition toAudioMixInputParameters:(AVMutableAudioMixInputParameters *)audioMixInputParameters;

+ (void)addTransition:(id<LBTransitionProtocol>)transition
     keepDurationTime:(CMTime)keepDurationTime
            withLayer:(CALayer *)layer
        toParentLayer:(CALayer *)parentLayer
             isAppear:(BOOL)isAppear;

+ (void)addDefaultTransitionInHost:(id<LBTimeProtocol>)host
                  keepDurationTime:(CMTime)keepDurationTime
                         withLayer:(CALayer *)layer
                     toParentLayer:(CALayer *)parentLayer
                   withVideoFrames:(int32_t)videoFrames
                          isAppear:(BOOL)isAppear;

@end
