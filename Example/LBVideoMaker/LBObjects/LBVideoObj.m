//
//  LBVideoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBVideoObj.h"

@implementation LBVideoObj

@synthesize framePerSecond = _framePerSecond;
@synthesize totalVideoTime;

@synthesize environments;
@synthesize scenes;

- (instancetype)initWithFramePerSecond:(int32_t)framePerSecond {
    if (self = [super init]) {
        _framePerSecond = framePerSecond;
    }
    return self;
}

- (CMTime)getSceneRelationTimeWithScene:(id<LBSceneProtocol>)scene {
    CMTime sceneTime = scene.timeRange.duration;
    if (scene.nextScene) {
        CMTime nextSceneTime = [self getSceneRelationTimeWithScene:scene.nextScene];
        sceneTime = CMTimeAdd(sceneTime, nextSceneTime);
    }
    return sceneTime;
}

#pragma mark - Getting

- (CMTime)totalVideoTime {
    __block CMTime totalVideoTime = kCMTimeZero;
    [self.scenes enumerateObjectsUsingBlock:^(id<LBSceneProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            totalVideoTime = [self getSceneRelationTimeWithScene:obj];
        } else {
            CMTime sceneTime = [self getSceneRelationTimeWithScene:obj];
            totalVideoTime = CMTimeAdd(totalVideoTime, sceneTime);
        }
    }];
    return totalVideoTime;
}

#pragma mark - Demo
#pragma mark - Video

+ (LBVideoObj *)createDemoObj {
    LBVideoObj *videoObj = [[LBVideoObj alloc] initWithFramePerSecond:30];
    videoObj.scenes = [self createScenesWithVideo:videoObj];
    videoObj.environments = [self createEnvironmentsWithVideo:videoObj];
    return videoObj;
}

#pragma mark - Create Scenes

+ (NSArray<LBSceneObj *> *)createScenesWithVideo:(LBVideoObj *)videoObj {
    LBSceneObj *headerSceneObj = [self createHeaderSceneWithDurationTime:CMTimeMakeWithSeconds(2.3, videoObj.framePerSecond)];
    headerSceneObj.contentVideo = videoObj;
    LBSceneObj *stepSceneObj = [self createStepSceneWithDurationTime:CMTimeMakeWithSeconds(4, videoObj.framePerSecond)];
    stepSceneObj.contentVideo = videoObj;
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(1.3, videoObj.framePerSecond)];
    footerSceneObj.contentVideo = videoObj;
    
    headerSceneObj.nextScene = stepSceneObj;
    stepSceneObj.nextScene = footerSceneObj;
    
    return @[headerSceneObj];
}

+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime sortType:LBSceneSortFirst];
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.4, durationTime.timescale);
    
    //color mask
//    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil durationTime:transitionTime isAppear:YES];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] durationTime:transitionTime isAppear:NO];
    
    //alpha
//    sceneObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0 toAlpha:1 durationTime:transitionTime];
//    sceneObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1 toAlpha:0 durationTime:transitionTime];
    
    return sceneObj;
}

+ (LBSceneObj *)createStepSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.4, durationTime.timescale);
    
    //color mask
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil durationTime:transitionTime isAppear:YES];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] durationTime:transitionTime isAppear:NO];
    
    //alpha
//    sceneObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0 toAlpha:1 durationTime:transitionTime];
//    sceneObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1 toAlpha:0 durationTime:transitionTime];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime sortType:LBSceneSortLast];
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.4, durationTime.timescale);
    
    //color mask
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil durationTime:transitionTime isAppear:YES];
//    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] durationTime:transitionTime isAppear:NO];
    
    //alpha
//    sceneObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0 toAlpha:1 durationTime:transitionTime];
//    sceneObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1 toAlpha:0 durationTime:transitionTime];
    
    return sceneObj;
}

#pragma mark - Create Environments

+ (NSSet<LBEnvironmentObj *> *)createEnvironmentsWithVideo:(LBVideoObj *)videoObj {
    LBVideoEnvironmentObj *videoEnvironmentObj = [self createVideoEnvironmentWithTotalVideoTime:videoObj.totalVideoTime];
    LBAudioEnvironmentObj *audioEnvironmentObj = [self createAudioEnvironmentWithTotalVideoTime:videoObj.totalVideoTime];
    
    return [NSSet setWithObjects:videoEnvironmentObj, audioEnvironmentObj, nil];
}

+ (LBVideoEnvironmentObj *)createVideoEnvironmentWithTotalVideoTime:(CMTime)totalVideoTime {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"bg_video" ofType:@"mov"];
    LBVideoEnvironmentObj *videoEnvironmentObj = [[LBVideoEnvironmentObj alloc] initWithVideoURL:[NSURL fileURLWithPath:videoPath] backgroundColor:[UIColor whiteColor]];
    videoEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, totalVideoTime);
    
//    CMTime appearDurationTime = CMTimeMakeWithSeconds(2.3, totalVideoTime.timescale);
//    videoEnvironmentObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0
//                                                                         toAlpha:1
//                                                                    durationTime:appearDurationTime];
//
//    CMTime disappearDurationTime = CMTimeMakeWithSeconds(1.3, totalVideoTime.timescale);
//    videoEnvironmentObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1
//                                                                            toAlpha:0
//                                                                       durationTime:disappearDurationTime];
    
    return videoEnvironmentObj;
}

+ (LBAudioEnvironmentObj *)createAudioEnvironmentWithTotalVideoTime:(CMTime)totalVideoTime {
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"bg_audio" ofType:@"mp3"];
    LBAudioEnvironmentObj *audioEnvironmentObj = [[LBAudioEnvironmentObj alloc] initWithAudioURL:[NSURL fileURLWithPath:audioPath]];
    audioEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, totalVideoTime);
    
    CMTime appearDurationTime = CMTimeMakeWithSeconds(2.3, totalVideoTime.timescale);
    audioEnvironmentObj.appear = [[LBVolumeTransitionObj alloc] initWithFromVolume:0
                                                                          toVolume:1
                                                                         durationTime:appearDurationTime];
    
    CMTime disappearDurationTime = CMTimeMakeWithSeconds(1.3, totalVideoTime.timescale);
    audioEnvironmentObj.disappear = [[LBVolumeTransitionObj alloc] initWithFromVolume:1
                                                                             toVolume:0
                                                                            durationTime:disappearDurationTime];
    
    return audioEnvironmentObj;
}

@end
