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
    return @"asfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdkasfdsdk";
}

+ (CGSize)videoSize {
    return CGSizeMake(720, 720);
}

+ (UIImage *)compareImage {
    NSURL *beforeImageURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"JPG"]];
    NSURL *afterImageURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"JPG"]];
    return [LBLayerHelper compareLayerImageWithBeforeImageURL:beforeImageURL
                                                afterImageURL:afterImageURL
                                                    videoSize:[LBDemoObj videoSize]];
}

+ (UIImage *)blurCompareImage {
    return [LBImageHelper blurImage:[LBDemoObj compareImage]];
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
    LBSceneObj *compareSceneObj = [self createCompareSceneWithDurationTime:CMTimeMakeWithSeconds(2.5, videoObj.framePerSecond)];
    LBSceneObj *productsSceneObj = [self createProductsSceneWithDurationTime:CMTimeMakeWithSeconds(2.4, videoObj.framePerSecond)];
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(1.7, videoObj.framePerSecond)];
    
    headerSceneObj.nextScene = stepSceneObj;
    stepSceneObj.nextScene = compareSceneObj;
    compareSceneObj.nextScene = productsSceneObj;
    productsSceneObj.nextScene = footerSceneObj;
    
    LBSceneObj *watermarkSceneObj = [self createWaterMarkSceneWithDurationTime:CMTimeMakeWithSeconds(15.7, videoObj.framePerSecond)];
    watermarkSceneObj.backgroundColor = [UIColor clearColor];
    
    return @[headerSceneObj,watermarkSceneObj];
}

#pragma mark - Header/Footer Scene
+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortFirst];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:CMTimeMakeWithSeconds(0.2, durationTime.timescale) isAppear:NO];
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortLast];
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
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
                                         timeRange:timeRange];
}

#pragma mark - Step Scene
+ (LBSceneObj *)createStepSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:transitionTime
                                                                 isAppear:YES];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
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
                                         timeRange:timeRange];
}

+ (LBPersonObj *)createStepPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepContentLayerWithVideoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:stepLayer
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
    CMTime appearTransitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:appearTransitionTime
                                                                 isAppear:YES];
    CMTime disAppearTransitionTime = CMTimeMakeWithSeconds(0.8, durationTime.timescale);
    sceneObj.disappear = [[LBContentsMaskTransitionObj alloc] initWithFromValue:[LBDemoObj compareImage]
                                                                        toValue:[LBDemoObj blurCompareImage]
                                                                   durationTime:disAppearTransitionTime
                                                                       isAppear:NO];
    
    LBPersonObj *compareImagesPersonObj = [self createCompareImagesPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(durationTime, disAppearTransitionTime))];
    LBPersonObj *detailPersonObj = [self createDetailPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(durationTime, disAppearTransitionTime))];
    sceneObj.persons = @[compareImagesPersonObj,detailPersonObj];
    return sceneObj;
}

+ (LBPersonObj *)createCompareImagesPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *compareLayer = [LBLayerHelper compareLayerWithContents:[LBDemoObj compareImage]
                                                          videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:compareLayer
                                                           timeRange:timeRange];
    
    return personObj;
}

+ (LBPersonObj *)createDetailPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *detailLayer = [LBLayerHelper detailLayerWithDetail:[LBDemoObj detail]
                                                      videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:detailLayer
                                                           timeRange:timeRange];
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, timeRange.duration.timescale);
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    
    return personObj;
}

#pragma mark - Products Scene
+ (LBSceneObj *)createProductsSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:transitionTime
                                                                    isAppear:NO];
    
    LBPersonObj *backgroundPersonObj = [self createProductsBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    CMTime pageProductStartTime = CMTimeMakeWithSeconds(0.3, durationTime.timescale);
    CMTime pageProductDurationTime = CMTimeSubtract(CMTimeSubtract(durationTime, pageProductStartTime), transitionTime);
    LBPersonObj *pageProductPersonObj = [self createPageProductPersonWithTimeRange:CMTimeRangeMake(pageProductStartTime, pageProductDurationTime)];
    sceneObj.persons = @[backgroundPersonObj,pageProductPersonObj];
    return sceneObj;
}

+ (LBPersonObj *)createProductsBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *compareLayer = [LBLayerHelper compareLayerWithContents:[LBDemoObj blurCompareImage]
                                                          videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:compareLayer
                                                           timeRange:timeRange];
    
    return personObj;
}

+ (LBPersonObj *)createPageProductPersonWithTimeRange:(CMTimeRange)timeRange {
    NSArray *products = @[
                          @{
                              @"title": @"11111111FFFFFFFFFFFFFFFFFFFFFFF",
                              @"url": [[NSBundle mainBundle] pathForResource:@"p1" ofType:@"png"]
                              },
                          @{
                              @"title": @"22222222FFFFFFFFFFFFFFFFFFFFFFF",
                              @"url": [[NSBundle mainBundle] pathForResource:@"p2" ofType:@"png"]
                              },
                          @{
                              @"title": @"33333333FFFFFFFFFFFFFFFFFFFFFFF",
                              @"url": [[NSBundle mainBundle] pathForResource:@"p3" ofType:@"png"]
                              },
                          @{
                              @"title": @"44444444FFFFFFFFFFFFFFFFFFFFFFF",
                              @"url": [[NSBundle mainBundle] pathForResource:@"p2" ofType:@"png"]
                              },
                          ];
    
    CALayer *productLayer = [LBLayerHelper productLayerWithProducts:products
                                                          videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:productLayer
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromValue:@0
                                                               toValue:@1
                                                          durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    return personObj;
}

#pragma mark - Watermark Scene

+ (LBSceneObj *)createWaterMarkSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortFirst];
    CMTimeRange whiteWatermarkPersonTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(2.7, durationTime.timescale), CMTimeMakeWithSeconds(4.4, durationTime.timescale));
    LBPersonObj *whiteWatermarkPersonObj = [self createWatermarkPersonWithTimeRange:whiteWatermarkPersonTimeRange color:[UIColor whiteColor]];
    CMTimeRange blackWatermarkPersonTimeRange = CMTimeRangeMake(CMTimeRangeGetEnd(whiteWatermarkPersonTimeRange), CMTimeMakeWithSeconds(4.9, durationTime.timescale));
    LBPersonObj *blackWatermarkPersonObj = [self createWatermarkPersonWithTimeRange:blackWatermarkPersonTimeRange color:[UIColor blackColor]];
    sceneObj.persons = @[whiteWatermarkPersonObj,blackWatermarkPersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createWatermarkPersonWithTimeRange:(CMTimeRange)timeRange color:(UIColor *)color {
    CALayer *watermarkLayer = [LBLayerHelper watermarkLayerWithTitle:[LBDemoObj title]
                                                            subTitle:[LBDemoObj subTitle]
                                                              author:[LBDemoObj author]
                                                                sign:[LBDemoObj sign]
                                                               color:color
                                                           videoSize:[LBDemoObj videoSize]];
    
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:watermarkLayer
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromValue:@0
                                                               toValue:@1
                                                          durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    return personObj;
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
    audioEnvironmentObj.appear = [[LBVolumeTransitionObj alloc] initWithFromValue:@0
                                                                          toValue:@1
                                                                     durationTime:appearDurationTime];
    
    CMTime disappearDurationTime = CMTimeMakeWithSeconds(1.3, totalVideoTime.timescale);
    audioEnvironmentObj.disappear = [[LBVolumeTransitionObj alloc] initWithFromValue:@1
                                                                             toValue:@0
                                                                        durationTime:disappearDurationTime];
    
    return audioEnvironmentObj;
}

@end
