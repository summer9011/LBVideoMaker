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

#pragma mark - Getting

- (CMTime)totalVideoTime {
    __block CMTime totalVideoTime = kCMTimeZero;
    [self.scenes enumerateObjectsUsingBlock:^(id<LBSceneProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalVideoTime = CMTimeAdd(totalVideoTime, obj.timeRange.duration);
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
    LBSceneObj *headerSceneObj = [self createHeaderSceneWithDurationTime:CMTimeMakeWithSeconds(5, videoObj.framePerSecond)];
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(3, videoObj.framePerSecond)];
    
    return @[headerSceneObj, footerSceneObj];
}

+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] init];
    sceneObj.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.5, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    CMTime startTime = CMTimeSubtract(CMTimeAdd(sceneObj.timeRange.start, sceneObj.timeRange.duration), transitionTime);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] timeRange:CMTimeRangeMake(startTime, transitionTime)];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] init];
    sceneObj.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.5, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    CMTime startTime = CMTimeSubtract(CMTimeAdd(sceneObj.timeRange.start, sceneObj.timeRange.duration), transitionTime);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] timeRange:CMTimeRangeMake(startTime, transitionTime)];
    
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
    
    return videoEnvironmentObj;
}

+ (LBAudioEnvironmentObj *)createAudioEnvironmentWithTotalVideoTime:(CMTime)totalVideoTime {
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"bg_audio" ofType:@"mp3"];
    LBAudioEnvironmentObj *audioEnvironmentObj = [[LBAudioEnvironmentObj alloc] initWithAudioURL:[NSURL fileURLWithPath:audioPath]];
    audioEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, totalVideoTime);
    
    CMTime durationTime = CMTimeMakeWithSeconds(2, totalVideoTime.timescale);
    audioEnvironmentObj.appear = [[LBVolumeTransitionObj alloc] initWithFromVolume:0
                                                                          toVolume:1
                                                                         timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    CMTime startTime = CMTimeSubtract(CMTimeAdd(audioEnvironmentObj.timeRange.start, audioEnvironmentObj.timeRange.duration), durationTime);
    audioEnvironmentObj.disappear = [[LBVolumeTransitionObj alloc] initWithFromVolume:1
                                                                             toVolume:0
                                                                            timeRange:CMTimeRangeMake(startTime, durationTime)];
    
    return audioEnvironmentObj;
}

@end
