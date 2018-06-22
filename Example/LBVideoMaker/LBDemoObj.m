//
//  LBDemoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/22.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBDemoObj.h"

@implementation LBDemoObj

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
    headerSceneObj.backgroundColor = [UIColor lightGrayColor];
    LBSceneObj *stepSceneObj = [self createStepSceneWithDurationTime:CMTimeMakeWithSeconds(4, videoObj.framePerSecond)];
    stepSceneObj.backgroundColor = [UIColor brownColor];
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(1.3, videoObj.framePerSecond)];
    footerSceneObj.backgroundColor = [UIColor darkGrayColor];
    
    headerSceneObj.nextScene = stepSceneObj;
    stepSceneObj.nextScene = footerSceneObj;
    
    return @[headerSceneObj];
}

#pragma mark - Header Scene
+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime sortType:LBSceneSortFirst];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] durationTime:CMTimeMakeWithSeconds(0.4, durationTime.timescale) isAppear:NO];
    
    CMTimeRange logoTimeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:logoTimeRange];
    CMTimeRange titleTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0.5, durationTime.timescale), CMTimeMakeWithSeconds(2, durationTime.timescale));
    LBPersonObj *titlePersonObj = [self createTitlePersonWithTimeRange:titleTimeRange];
    sceneObj.persons = @[logoPersonObj,titlePersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createLogoPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *logoLayer = [CALayer layer];
    logoLayer.backgroundColor = [UIColor greenColor].CGColor;
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:logoLayer
                                                         percentRect:CGRectMake(0.2, 0.2, 0.6, 0.6)
                                                           timeRange:timeRange];
    return personObj;
}

+ (LBPersonObj *)createTitlePersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *titleLayer = [CALayer layer];
    titleLayer.backgroundColor = [UIColor redColor].CGColor;
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:titleLayer
                                                       percentCenter:CGPointMake(0.5, 0.5)
                                                        specificSize:CGSizeMake(50, 50)
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.4, timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0 toAlpha:1 durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1 toAlpha:0 durationTime:transitionTime];
    return personObj;
}

#pragma mark - Step Scene
+ (LBSceneObj *)createStepSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.4, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil durationTime:transitionTime isAppear:YES];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil toColor:[UIColor whiteColor] durationTime:transitionTime isAppear:NO];
    return sceneObj;
}

#pragma mark - Footer Scene
+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime sortType:LBSceneSortLast];
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor] toColor:nil durationTime:CMTimeMakeWithSeconds(0.4, durationTime.timescale) isAppear:YES];
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
