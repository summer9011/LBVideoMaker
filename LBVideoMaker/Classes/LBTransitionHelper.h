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

+ (void)addTransition:(id<LBTransitionProtocol>)transition withLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer;
+ (void)addDefaultAppearTransitionWithLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer;
+ (void)addDefaultDisappearTransitionWithLayer:(CALayer *)layer toParentLayer:(CALayer *)parentLayer;

@end
