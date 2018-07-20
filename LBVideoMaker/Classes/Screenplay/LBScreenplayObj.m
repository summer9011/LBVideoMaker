//
//  LBScreenplayObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBScreenplayObj.h"
#import "LBVideoProtocol.h"

//Screenplay
NSString * const LBScreenplayKeyName = @"name";
NSString * const LBScreenplayKeyIsCustomAudio = @"isCustomAudio";
NSString * const LBScreenplayKeyIsCustomVideo = @"isCustomVideo";

//video
NSString * const LBVideoKeyFrame = @"frame";
NSString * const LBVideoKeyVideoSize = @"videoSize";
NSString * const LBVideoKeyEnvironments = @"environments";
NSString * const LBVideoKeyScenes = @"scenes";

//transition
NSString * const LBTransitionKeyType = @"type";
NSString * const LBTransitionKeyType_Volume = @"volume";
NSString * const LBTransitionKeyType_Alpha = @"alpha";
NSString * const LBTransitionKeyType_ColorMask = @"colorMask";
NSString * const LBTransitionKeyType_ContentMask = @"contentMask";

NSString * const LBTransitionKeyFromValue = @"fromValue";
NSString * const LBTransitionKeyToValue = @"toValue";

NSString * const LBTransitionKeyIsCustom = @"isCustom";

//time
NSString * const LBTimeKeyStart = @"start";
NSString * const LBTimeKeyDuration = @"duration";

//scene
NSString * const LBSceneKeySort = @"sort";
NSString * const LBSceneKeySort_Default = @"default";
NSString * const LBSceneKeySort_First = @"first";
NSString * const LBSceneKeySort_Last = @"last";

NSString * const LBSceneKeyBackground = @"background";
NSString * const LBSceneKeyPersons = @"persons";
NSString * const LBSceneKeyAppear = @"appear";
NSString * const LBSceneKeyDisappear = @"disappear";
NSString * const LBSceneKeyNextScene = @"nextScene";

//person
NSString * const LBPersonKeyAppearance = @"appearance";
NSString * const LBPersonKeyBehaviors = @"behaviors";
NSString * const LBPersonKeyAppear = @"appear";
NSString * const LBPersonKeyDisappear = @"disappear";

//environment
NSString * const LBEnvironmentKeyType = @"type";
NSString * const LBEnvironmentKeyType_Audio = @"audio";
NSString * const LBEnvironmentKeyType_Video = @"video";

NSString * const LBEnvironmentKeyAppear = @"appear";
NSString * const LBEnvironmentKeyDisappear = @"disappear";
NSString * const LBEnvironmentKeyNextEnvironment = @"nextEnvironment";
NSString * const LBEnvironmentKeyURL = @"url";
NSString * const LBEnvironmentKeyBackground = @"background";

//behavior
NSString * const LBBehaviorKeyType = @"type";
NSString * const LBBehaviorKeyType_ContentGradient = @"contentGradient";
NSString * const LBBehaviorKeyType_Move = @"move";
NSString * const LBBehaviorKeyType_Zoom = @"zoom";
NSString * const LBBehaviorKeyType_Transform = @"transform";

NSString * const LBBehaviorKeyRepeat = @"repeat";
NSString * const LBBehaviorKeyAutoReverses = @"autoreverses";

NSString * const LBBehaviorKeyTimingFunctionNames = @"timingFunctionNames";
NSString * const LBBehaviorKeyBackwards = @"backwards";
NSString * const LBBehaviorKeyForwards = @"forwards";

NSString * const LBBehaviorKeyNextBehavior = @"nextBehavior";

NSString * const LBBehaviorKeyIsCustom = @"isCustom";

NSString * const LBBehaviorKeyImages = @"images";
NSString * const LBBehaviorKeyPositions = @"positions";
NSString * const LBBehaviorKeyBezierPath = @"bezierPath";
NSString * const LBBehaviorKeyZooms = @"zooms";
NSString * const LBBehaviorKeyKeyPath = @"keyPath";
NSString * const LBBehaviorKeyTransfroms = @"transforms";

@implementation LBScreenplayObj

- (instancetype)init {
    if (self = [super init]) {
        self.screenplayName = [[NSUUID UUID].UUIDString lowercaseString];
        self.videoSize = CGSizeMake(720, 720);
        self.frames = 60;
        self.customBackgroundAudio = NO;
        self.customBackgroundVideo = NO;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *screenplay = @{
                                 LBScreenplayKeyName: self.screenplayName,
                                 LBScreenplayKeyIsCustomAudio: @(self.customBackgroundAudio),
                                 LBScreenplayKeyIsCustomVideo: @(self.customBackgroundVideo),
                                 LBVideoKeyFrame: @(self.frames),
                                 LBVideoKeyVideoSize: [NSValue valueWithCGSize:self.videoSize],
                                 LBVideoKeyEnvironments: @[
                                         ],
                                 LBVideoKeyScenes: @[
                                         ],
                                 };
    return [NSString stringWithFormat:@"%@", screenplay];
}

@end
