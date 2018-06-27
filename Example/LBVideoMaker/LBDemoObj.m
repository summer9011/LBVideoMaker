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

+ (NSString *)videoPath {
    return [[NSBundle mainBundle] pathForResource:@"bg_video" ofType:@"mov"];
}

+ (NSString *)audioPath {
    return [[NSBundle mainBundle] pathForResource:@"bg_audio" ofType:@"mp3"];
}

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
    return @"Hello world 12345!";
}

+ (int32_t)frames {
    return 30;
}

+ (CGSize)videoSize {
    return CGSizeMake(720, 720);
}

+ (NSString *)toolImagePathWithName:(NSString *)name {
    return [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
}

+ (NSArray<NSString *> *)images {
    return @[
             [[NSBundle mainBundle] pathForResource:@"1" ofType:@"JPG"],
             [[NSBundle mainBundle] pathForResource:@"2" ofType:@"JPG"],
             [[NSBundle mainBundle] pathForResource:@"3" ofType:@"JPG"],
             [[NSBundle mainBundle] pathForResource:@"4" ofType:@"JPG"]
             ];
}

+ (NSArray<NSDictionary<NSString *, NSString *> *> *)products {
    return @[
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
                 }
             ];
}

+ (UIImage *)compareImage {
    NSArray<NSString *> *imagePaths = [LBDemoObj images];
    return [LBLayerHelper compareLayerImageWithBeforeImagePath:imagePaths.firstObject
                                                afterImagePath:imagePaths.lastObject
                                                     videoSize:[LBDemoObj videoSize]];
}

+ (UIImage *)blurCompareImage {
    return [LBImageHelper blurImage:[LBDemoObj compareImage]];
}

+ (NSTimeInterval)normalTransitionTime {
    return 0.2;
}

+ (NSTimeInterval)longTransitionTime {
    return 0.8;
}

#pragma mark - Demo
#pragma mark - Video

+ (LBVideoObj *)createDemoObj {
    LBVideoObj *videoObj = [[LBVideoObj alloc] initWithFramePerSecond:[LBDemoObj frames] videoSize:[LBDemoObj videoSize]];
    videoObj.scenes = [self createScenesWithVideo:videoObj];
    videoObj.environments = [self createEnvironmentsWithVideo:videoObj];
    return videoObj;
}

#pragma mark - Create Scenes

+ (NSArray<LBSceneObj *> *)createScenesWithVideo:(LBVideoObj *)videoObj {
    NSTimeInterval headerTotalTime = 2.5 + [LBDemoObj normalTransitionTime];
    LBSceneObj *headerSceneObj = [self createHeaderSceneWithDurationTime:CMTimeMakeWithSeconds(headerTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval stepTotalTime = 1 * [LBDemoObj images].count + [LBDemoObj normalTransitionTime] * 2;
    LBSceneObj *stepSceneObj = [self createStepSceneWithDurationTime:CMTimeMakeWithSeconds(stepTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval compareTotalTime = 1.5 + [LBDemoObj normalTransitionTime] + [LBDemoObj longTransitionTime];
    LBSceneObj *compareSceneObj = [self createCompareSceneWithDurationTime:CMTimeMakeWithSeconds(compareTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval productsTotalTime = 0;
    LBSceneObj *productsSceneObj = nil;
    if ([LBDemoObj products].count > 0) {
        productsTotalTime = 2 + [LBDemoObj normalTransitionTime];
        productsSceneObj = [self createProductsSceneWithDurationTime:CMTimeMakeWithSeconds(productsTotalTime, videoObj.framePerSecond)];
    }
    
    NSTimeInterval footerTotalTime = 1.5 + [LBDemoObj normalTransitionTime];
    LBSceneObj *footerSceneObj = [self createFooterSceneWithDurationTime:CMTimeMakeWithSeconds(footerTotalTime, videoObj.framePerSecond)];
    
    headerSceneObj.nextScene = stepSceneObj;
    stepSceneObj.nextScene = compareSceneObj;
    if (productsSceneObj) {
        compareSceneObj.nextScene = productsSceneObj;
        productsSceneObj.nextScene = footerSceneObj;
    } else {
        compareSceneObj.nextScene = footerSceneObj;
    }
    
    NSTimeInterval totalTime = headerTotalTime + stepTotalTime + compareTotalTime + productsTotalTime + footerTotalTime;
    CMTime totalDurationTime = CMTimeMakeWithSeconds(totalTime, videoObj.framePerSecond);
    LBSceneObj *watermarkSceneObj = [self createWatermarkSceneWithStartTime:CMTimeMakeWithSeconds(headerTotalTime, videoObj.framePerSecond)
                                                 whiteWatermarkDurationTime:CMTimeMakeWithSeconds(stepTotalTime, videoObj.framePerSecond)
                                                 blackWatermarkDurationTime:CMTimeMakeWithSeconds(compareTotalTime + productsTotalTime, videoObj.framePerSecond)
                                                          totalDurationTime:totalDurationTime];
    watermarkSceneObj.backgroundColor = [UIColor clearColor];
    
    return @[headerSceneObj,watermarkSceneObj];
}

#pragma mark - Header/Footer Scene
+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortFirst];
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], durationTime.timescale)
                                                                    isAppear:NO];
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortLast];
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], durationTime.timescale)
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
    
    CMTime transitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], durationTime.timescale);
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
    
    CMTime offsetTime = CMTimeMakeWithSeconds(0.2, durationTime.timescale);
    CMTime toolDurationTime = CMTimeMakeWithSeconds(2, durationTime.timescale);
    
    CMTime toolBeginTime = CMTimeAdd(transitionTime, offsetTime);
    CMTimeRange timeRange = CMTimeRangeMake(toolBeginTime, toolDurationTime);
    LBPersonObj *eyeToolPersonObj = [self createStepToolPersonWithImageName:@"eye" timeRange:timeRange];
    
//    toolBeginTime = CMTimeAdd(CMTimeRangeGetEnd(timeRange), offsetTime);
//    timeRange = CMTimeRangeMake(toolBeginTime, toolDurationTime);
//    LBPersonObj *faceToolPersonObj = [self createStepToolPersonWithImageName:@"face" timeRange:timeRange];
    
//    toolBeginTime = CMTimeAdd(CMTimeRangeGetEnd(timeRange), offsetTime);
//    timeRange = CMTimeRangeMake(toolBeginTime, toolDurationTime);
//    LBPersonObj *lipToolPersonObj = [self createStepToolPersonWithImageName:@"lip" timeRange:timeRange];
    
    sceneObj.persons = @[backgroundPersonObj,
                         stepPersonObj,
//                         eyeToolPersonObj,
//                         faceToolPersonObj,
//                         lipToolPersonObj
                         ];
    
    return sceneObj;
}

+ (LBPersonObj *)createStepBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepLayerWithImagePath:[LBDemoObj images].firstObject
                                                     videoSize:[LBDemoObj videoSize]];
    return [[LBPersonObj alloc] initWithAppearance:stepLayer
                                         timeRange:timeRange];
}

+ (LBPersonObj *)createStepPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepContentLayerWithVideoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:stepLayer
                                                           timeRange:timeRange];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    [[LBDemoObj images] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images addObject:[UIImage imageWithContentsOfFile:obj]];
    }];
    
    
    CMTimeRange behaviorTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], timeRange.duration.timescale));
    LBContentsGradientBehaviorObj *beforeStepBehaviorObj = [[LBContentsGradientBehaviorObj alloc] initWithImages:@[images.firstObject]
                                                                                                       timeRange:behaviorTimeRange];
    
    
    CMTime behaviorDurationTime = CMTimeSubtract(timeRange.duration, CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime]*2, timeRange.duration.timescale));
    behaviorTimeRange = CMTimeRangeMake(CMTimeRangeGetEnd(behaviorTimeRange), behaviorDurationTime);
    LBContentsGradientBehaviorObj *behaviorObj = [[LBContentsGradientBehaviorObj alloc] initWithImages:images
                                                                                             timeRange:behaviorTimeRange];
    
    behaviorTimeRange = CMTimeRangeMake(CMTimeRangeGetEnd(behaviorTimeRange), CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], timeRange.duration.timescale));
    LBContentsGradientBehaviorObj *afterStepBehaviorObj = [[LBContentsGradientBehaviorObj alloc] initWithImages:@[images.lastObject]
                                                                                                      timeRange:behaviorTimeRange];
    
    
    personObj.behaviors = @[beforeStepBehaviorObj,behaviorObj,afterStepBehaviorObj];
    
    return personObj;
}

+ (LBPersonObj *)createStepToolPersonWithImageName:(NSString *)imageName timeRange:(CMTimeRange)timeRange {
    CGPoint point1 = CGPointMake(200, 200);
    CGPoint point2 = CGPointMake(220, 200);
    
    CALayer *toolLayer = [LBLayerHelper imageLayerWithImagePath:[LBDemoObj toolImagePathWithName:imageName]
                                                      videoSize:[LBDemoObj videoSize]];
    CGPoint position = toolLayer.position;
    position = point1;
    toolLayer.position = position;
    
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:toolLayer
                                                           timeRange:timeRange];
    
    CMTime transitionTime = CMTimeMakeWithSeconds(0.2, timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromValue:@0
                                                               toValue:@1
                                                          durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    
    NSArray *positions = @[
                           [NSValue valueWithCGPoint:point1],
                           [NSValue valueWithCGPoint:point2],
                           [NSValue valueWithCGPoint:point1],
//                           [NSValue valueWithCGPoint:point4]
                           ];
    
    CMTime behaviorDurationTime = CMTimeSubtract(CMTimeSubtract(timeRange.duration, transitionTime), transitionTime);
    CMTimeRange behaviorTimeRange = CMTimeRangeMake(timeRange.start, behaviorDurationTime);
    LBMovesBehaviorObj *behavior = [[LBMovesBehaviorObj alloc] initWithPositions:positions timeRange:behaviorTimeRange];
    behavior.timingFunctionNames = @[
                                     kCAMediaTimingFunctionEaseIn,
                                     kCAMediaTimingFunctionLinear,
//                                     kCAMediaTimingFunctionEaseOut
                                     ];
    personObj.behaviors = @[behavior];
    
    return personObj;
}

#pragma mark - Compare Scene
+ (LBSceneObj *)createCompareSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime appearTransitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:appearTransitionTime
                                                                 isAppear:YES];
    CMTime disAppearTransitionTime = CMTimeMakeWithSeconds([LBDemoObj longTransitionTime], durationTime.timescale);
    sceneObj.disappear = [[LBContentsMaskTransitionObj alloc] initWithFromValue:[LBDemoObj compareImage]
                                                                        toValue:[LBDemoObj blurCompareImage]
                                                                   durationTime:disAppearTransitionTime
                                                                       isAppear:NO];
    
    CMTime personDurationTime = CMTimeSubtract(durationTime, disAppearTransitionTime);
    CMTimeRange personTimeRange = CMTimeRangeMake(kCMTimeZero, personDurationTime);
    
    LBPersonObj *compareImagesPersonObj = [self createCompareImagesPersonWithTimeRange:personTimeRange];
    LBPersonObj *detailPersonObj = [self createDetailPersonWithTimeRange:personTimeRange];
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
    
    CMTime transitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], timeRange.duration.timescale);
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    
    return personObj;
}

#pragma mark - Products Scene
+ (LBSceneObj *)createProductsSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], durationTime.timescale);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:transitionTime
                                                                    isAppear:NO];
    
    LBPersonObj *backgroundPersonObj = [self createProductsBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    
    CMTime pageProductStartTime = CMTimeMakeWithSeconds(0.3, durationTime.timescale);
    CMTime pageProductDurationTime = CMTimeSubtract(CMTimeSubtract(durationTime, pageProductStartTime), transitionTime);
    CMTimeRange pageProductTimeRange = CMTimeRangeMake(pageProductStartTime, pageProductDurationTime);
    LBPersonObj *pageProductPersonObj = [self createPageProductPersonWithTimeRange:pageProductTimeRange];
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
    CALayer *productLayer = [LBLayerHelper productLayerWithProducts:[LBDemoObj products]
                                                          videoSize:[LBDemoObj videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:productLayer
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromValue:@0
                                                               toValue:@1
                                                          durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    return personObj;
}

#pragma mark - Watermark Scene

+ (LBSceneObj *)createWatermarkSceneWithStartTime:(CMTime)startTime
                       whiteWatermarkDurationTime:(CMTime)whiteDurationTime
                       blackWatermarkDurationTime:(CMTime)blackDurationTime
                                totalDurationTime:(CMTime)totalDurationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:totalDurationTime
                                                           sortType:LBSceneSortFirst];
    
    CMTimeRange whiteWatermarkPersonTimeRange = CMTimeRangeMake(startTime, whiteDurationTime);
    LBPersonObj *whiteWatermarkPersonObj = [self createWatermarkPersonWithTimeRange:whiteWatermarkPersonTimeRange color:[UIColor whiteColor]];
    
    CMTimeRange blackWatermarkPersonTimeRange = CMTimeRangeMake(CMTimeRangeGetEnd(whiteWatermarkPersonTimeRange), blackDurationTime);
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
    CMTime transitionTime = CMTimeMakeWithSeconds([LBDemoObj normalTransitionTime], timeRange.duration.timescale);
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
    LBVideoEnvironmentObj *videoEnvironmentObj = [[LBVideoEnvironmentObj alloc] initWithVideoURL:[NSURL fileURLWithPath:[LBDemoObj videoPath]] backgroundColor:[UIColor whiteColor]];
    videoEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, totalVideoTime);
    
    return videoEnvironmentObj;
}

+ (LBAudioEnvironmentObj *)createAudioEnvironmentWithTotalVideoTime:(CMTime)totalVideoTime {
    LBAudioEnvironmentObj *audioEnvironmentObj = [[LBAudioEnvironmentObj alloc] initWithAudioURL:[NSURL fileURLWithPath:[LBDemoObj audioPath]]];
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
