//
//  LBDemoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/22.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBDemoObj.h"
#import "LBLayerHelper.h"

@implementation LBDemoObj

+ (NSString *)logoPath {
    return [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
}

+ (NSString *)title {
    return @"Glam Summer 2018";
}

+ (NSString *)subTitle {
    return @"Created by Angela Smith";
}

+ (NSString *)author {
    return @"Angela Smith";
}

+ (NSString *)sign {
    return @"Powered by Perfect365 PRO";
}

+ (NSString *)detail {
    return @"asfdsdkfjsa;ldfjsldfhasldhflskjdfhakshfoisbflajskfhsaklfhaslfd";
}

+ (CGSize)videoSize {
    return CGSizeMake(720, 720);
}

#pragma mark - Demo
#pragma mark - Video

+ (LBVideoObj *)createDemoObj {
    LBVideoObj *videoObj = [[LBVideoObj alloc] initWithFramePerSecond:30 videoSize:[LBDemoObj videoSize]];
    videoObj.scenes = [self createScenesWithVideo:videoObj];
    videoObj.environments = [self createEnvironmentsWithVideo:videoObj];
    return videoObj;
}

#pragma mark - Create Scenes

+ (NSArray<LBSceneObj *> *)createScenesWithVideo:(LBVideoObj *)videoObj {
    LBSceneObj *headerSceneObj = [self createHeaderSceneWithDurationTime:CMTimeMakeWithSeconds(2.7, videoObj.framePerSecond)];
    LBSceneObj *stepSceneObj = [self createStepSceneWithDurationTime:CMTimeMakeWithSeconds(4.4, videoObj.framePerSecond)];
    LBSceneObj *compareSceneObj = [self createCompareSceneWithDurationTime:CMTimeMakeWithSeconds(2.4, videoObj.framePerSecond)];
    LBSceneObj *productsSceneObj = [self createProductsSceneWithDurationTime:CMTimeMakeWithSeconds(2.4, videoObj.framePerSecond)];
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(1.7, videoObj.framePerSecond)];
    
    headerSceneObj.nextScene = stepSceneObj;
    stepSceneObj.nextScene = compareSceneObj;
    compareSceneObj.nextScene = productsSceneObj;
    productsSceneObj.nextScene = footerSceneObj;
    
    return @[headerSceneObj];
}

#pragma mark - Header/Footer Scene
+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortFirst];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil
                                                                     toColor:[UIColor whiteColor]
                                                                durationTime:CMTimeMakeWithSeconds(0.2, durationTime.timescale)
                                                                    isAppear:NO];
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortLast];
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor]
                                                                  toColor:nil
                                                             durationTime:CMTimeMakeWithSeconds(0.2, durationTime.timescale)
                                                                 isAppear:YES];
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createLogoPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *logoLayer = [LBLayerHelper headLayerWithLogoPath:[LBDemoObj logoPath]
                                                        title:[LBDemoObj title]
                                                     subTitle:[LBDemoObj subTitle]
                                                       author:[LBDemoObj author]
                                                         sign:[LBDemoObj sign]
                                                    videoSize:[LBDemoObj videoSize]];
    
    return [[LBPersonObj alloc] initWithAppearance:logoLayer
                                     percentCenter:CGPointMake(0.5, 0.45)
                                      specificSize:logoLayer.bounds.size
                                         timeRange:timeRange];
}

#pragma mark - Step Scene
+ (LBSceneObj *)createStepSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor]
                                                                  toColor:nil
                                                             durationTime:transitionTime
                                                                 isAppear:YES];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil
                                                                     toColor:[UIColor whiteColor]
                                                                durationTime:transitionTime
                                                                    isAppear:NO];
    
    LBPersonObj *backgroundPersonObj = [self createStepBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    LBPersonObj *stepPersonObj = [self createStepPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[backgroundPersonObj,stepPersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createStepBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    NSURL *imageURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"JPG"]];
    CALayer *stepLayer = [LBLayerHelper stepLayerWithImageURL:imageURL
                                                    videoSize:[LBDemoObj videoSize]];
    
    return [[LBPersonObj alloc] initWithAppearance:stepLayer
                                       percentRect:CGRectMake(0, 0, 1, 1)
                                         timeRange:timeRange];
}

+ (LBPersonObj *)createStepPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepContentLayerWithVideoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:stepLayer
                                                         percentRect:CGRectMake(0, 0, 1, 1)
                                                           timeRange:timeRange];
    
    NSArray<NSURL *> *imageURLs = @[
                                    [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"JPG"]],
                                    [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"JPG"]],
                                    [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"JPG"]],
                                    [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"JPG"]]
                                    ];
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    [imageURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images addObject:[UIImage imageWithContentsOfFile:obj.absoluteString]];
    }];
    
    LBContentsGradientBehaviorObj *behaviorObj = [[LBContentsGradientBehaviorObj alloc] initWithImages:images
                                                                                             timeRange:timeRange];
    personObj.behaviors = @[behaviorObj];
    
    return personObj;
}

#pragma mark - Compare Scene
+ (LBSceneObj *)createCompareSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromColor:[UIColor whiteColor]
                                                                  toColor:nil
                                                             durationTime:transitionTime
                                                                 isAppear:YES];
    sceneObj.disappear = [[LBBlurMaskTransitionObj alloc] initWithDurationTime:transitionTime
                                                                      isAppear:NO];
    
    LBPersonObj *compareImagesPersonObj = [self createCompareImagesPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    LBPersonObj *detailPersonObj = [self createDetailPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[compareImagesPersonObj,detailPersonObj];
    return sceneObj;
}

+ (LBPersonObj *)createCompareImagesPersonWithTimeRange:(CMTimeRange)timeRange {
    NSURL *beforeImageURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"JPG"]];
    NSURL *afterImageURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"JPG"]];
    CALayer *compareLayer = [LBLayerHelper compareLayerWithBeforeImageURL:beforeImageURL
                                                            afterImageURL:afterImageURL
                                                                videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:compareLayer
                                                       percentCenter:CGPointMake(0, 0) specificSize:compareLayer.bounds.size
                                                           timeRange:timeRange];
    
    return personObj;
}

+ (LBPersonObj *)createDetailPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *detailLayer = [LBLayerHelper detailLayerWithDetail:[LBDemoObj detail]
                                                      videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:detailLayer
                                                       percentCenter:CGPointMake(0, 0) specificSize:detailLayer.bounds.size
                                                           timeRange:timeRange];
    
    return personObj;
}

#pragma mark - Products Scene
+ (LBSceneObj *)createProductsSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromColor:nil
                                                                     toColor:[UIColor whiteColor]
                                                                durationTime:transitionTime
                                                                    isAppear:NO];
    
    LBPersonObj *backgroundPersonObj = [self createProductsBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    LBPersonObj *pageProductPersonObj = [self createPageProductPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[backgroundPersonObj,pageProductPersonObj];
    return sceneObj;
}

+ (LBPersonObj *)createProductsBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    
}

+ (LBPersonObj *)createPageProductPersonWithTimeRange:(CMTimeRange)timeRange {
    
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
