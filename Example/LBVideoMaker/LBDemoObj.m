//
//  LBDemoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/22.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBDemoObj.h"
#import "LBLayerHelper.h"

#import "LBCustomBehaviorObj.h"
#import "LBCustomTransitionObj.h"

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
    return 60;
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
    NSArray<NSString *> *imagePaths = [self images];
    return [LBLayerHelper compareLayerImageWithBeforeImagePath:imagePaths.firstObject
                                                afterImagePath:imagePaths.lastObject
                                                     videoSize:[self videoSize]];
}

+ (UIImage *)blurCompareImage {
    return [LBImageHelper blurImage:[self compareImage]];
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
    LBVideoObj *videoObj = [[LBVideoObj alloc] initWithFramePerSecond:[self frames] videoSize:[self videoSize]];
    videoObj.scenes = [self createScenesWithVideo:videoObj];
    videoObj.environments = [self createEnvironmentsWithVideo:videoObj];
    return videoObj;
}

#pragma mark - Create Scenes

+ (NSArray<LBSceneObj *> *)createScenesWithVideo:(LBVideoObj *)videoObj {
    NSTimeInterval headerTotalTime = 2.5 + [self normalTransitionTime];
    LBSceneObj *headerSceneObj = [self createHeaderSceneWithDurationTime:CMTimeMakeWithSeconds(headerTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval stepTotalTime = 1 * [self images].count + [self normalTransitionTime] * 2;
    LBSceneObj *stepSceneObj = [self createStepSceneWithDurationTime:CMTimeMakeWithSeconds(stepTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval compareTotalTime = 1.5 + [self normalTransitionTime] + [self longTransitionTime];
    LBSceneObj *compareSceneObj = [self createCompareSceneWithDurationTime:CMTimeMakeWithSeconds(compareTotalTime, videoObj.framePerSecond)];
    
    NSTimeInterval productsTotalTime = 0;
    LBSceneObj *productsSceneObj = nil;
    if ([self products].count > 0) {
        productsTotalTime = 2 + [self normalTransitionTime];
        productsSceneObj = [self createProductsSceneWithDurationTime:CMTimeMakeWithSeconds(productsTotalTime, videoObj.framePerSecond)];
    }
    
    NSTimeInterval footerTotalTime = 1.5 + [self normalTransitionTime];
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
    
    return @[headerSceneObj,watermarkSceneObj];
}

#pragma mark - Header/Footer Scene
+ (LBSceneObj *)createHeaderSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortFirst];
    
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale);
    /*
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:transitionTime];
     */
    
    //Custom Transition
    LBCustomTransitionObj *customDisappearTransition = [LBCustomTransitionObj transitionWithBlock:^(CALayer *layer, CALayer *parentLayer, CFTimeInterval keepTime) {
        CFTimeInterval duration = CMTimeGetSeconds(transitionTime);
        CFTimeInterval beginTime = CMTimeGetSeconds(durationTime) - duration;
        
        CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomAnimation.fromValue = @1;
        zoomAnimation.toValue = @0;
        zoomAnimation.beginTime = 0;
        zoomAnimation.duration = duration;
        zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(360, 360)];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(720, 720)];
        moveAnimation.beginTime = 0;
        moveAnimation.duration = duration;
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.beginTime = beginTime;
        animationGroup.duration = duration;
        animationGroup.animations = @[zoomAnimation,moveAnimation];
        [layer addAnimation:animationGroup forKey:nil];
    }];
    sceneObj.disappear = customDisappearTransition;
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBSceneObj *)createFooterSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime
                                                           sortType:LBSceneSortLast];
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale)];
    
    LBPersonObj *logoPersonObj = [self createLogoPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    sceneObj.persons = @[logoPersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createLogoPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *logoLayer = [LBLayerHelper headLayerWithLogoPath:[self logoPath]
                                                        title:[self title]
                                                     subTitle:[self subTitle]
                                                       author:[self author]
                                                         sign:[self sign]
                                                    videoSize:[self videoSize]];
    
    return [[LBPersonObj alloc] initWithAppearance:logoLayer
                                         timeRange:timeRange];
}

#pragma mark - Step Scene
+ (LBSceneObj *)createStepSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale);
    
    /*
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:transitionTime];
     */
    
    //Custom Transition
    LBCustomTransitionObj *customAppearTransition = [LBCustomTransitionObj transitionWithBlock:^(CALayer *layer, CALayer *parentLayer, CFTimeInterval keepTime) {
        CFTimeInterval duration = CMTimeGetSeconds(transitionTime);
        CFTimeInterval beginTime = 2.5 + [self normalTransitionTime];
        
        CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomAnimation.fromValue = @0;
        zoomAnimation.toValue = @1;
        zoomAnimation.beginTime = 0;
        zoomAnimation.duration = duration;
        zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(720, 720)];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(360, 360)];
        moveAnimation.beginTime = 0;
        moveAnimation.duration = duration;
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.beginTime = beginTime;
        animationGroup.duration = duration;
        animationGroup.animations = @[zoomAnimation,moveAnimation];
        [layer addAnimation:animationGroup forKey:nil];
    }];
    sceneObj.appear = customAppearTransition;
    
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:transitionTime];
    
    LBPersonObj *backgroundPersonObj = [self createStepBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    LBPersonObj *stepPersonObj = [self createStepPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    
    CMTime dTime = CMTimeMakeWithSeconds(1, durationTime.timescale);
    
    CMTime sTime = CMTimeAdd(transitionTime, transitionTime);
    CMTimeRange timeRange = CMTimeRangeMake(sTime, dTime);
    LBPersonObj *faceToolPersonObj = [self createStepToolPersonWithImageName:@"face"
                                                                   fromPoint:CGPointMake(240, 370)
                                                                     toPoint:CGPointMake(260, 370)
                                                                   timeRange:timeRange];
    
    sTime = CMTimeRangeGetEnd(timeRange);
    timeRange = CMTimeRangeMake(sTime, dTime);
    LBPersonObj *eyeToolPersonObj = [self createStepToolPersonWithImageName:@"eye"
                                                                  fromPoint:CGPointMake(460, 330)
                                                                    toPoint:CGPointMake(486, 330)
                                                                  timeRange:timeRange];
    
    sTime = CMTimeRangeGetEnd(timeRange);
    timeRange = CMTimeRangeMake(sTime, dTime);
    LBPersonObj *lipToolPersonObj = [self createStepToolPersonWithImageName:@"lip"
                                                                  fromPoint:CGPointMake(380, 490)
                                                                    toPoint:CGPointMake(400, 490)
                                                                  timeRange:timeRange];
    
    sceneObj.persons = @[backgroundPersonObj,
                         stepPersonObj,
                         faceToolPersonObj,
                         eyeToolPersonObj,
                         lipToolPersonObj
                         ];
    
    return sceneObj;
}

+ (LBPersonObj *)createStepBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepLayerWithImagePath:[self images].firstObject
                                                     videoSize:[self videoSize]];
    return [[LBPersonObj alloc] initWithAppearance:stepLayer
                                         timeRange:timeRange];
}

+ (LBPersonObj *)createStepPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *stepLayer = [LBLayerHelper stepContentLayerWithVideoSize:[self videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:stepLayer
                                                           timeRange:timeRange];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    [[self images] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images addObject:[UIImage imageWithContentsOfFile:obj]];
    }];
    
    CMTime behaviorDurationTime = CMTimeSubtract(timeRange.duration, CMTimeMakeWithSeconds([self normalTransitionTime]*2, timeRange.duration.timescale));
    CMTimeRange behaviorTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds([self normalTransitionTime], timeRange.duration.timescale), behaviorDurationTime);
    LBContentGradientBehaviorObj *behaviorObj = [[LBContentGradientBehaviorObj alloc] initWithImages:images
                                                                                             timeRange:behaviorTimeRange];
    behaviorObj.extendBackwards = YES;
    behaviorObj.extendForwards = YES;
    personObj.behaviors = @[behaviorObj];
    
    return personObj;
}

+ (LBPersonObj *)createStepToolPersonWithImageName:(NSString *)imageName
                                         fromPoint:(CGPoint)fromPoint
                                           toPoint:(CGPoint)toPoint
                                         timeRange:(CMTimeRange)timeRange {
    CALayer *toolLayer = [LBLayerHelper imageLayerWithImagePath:[self toolImagePathWithName:imageName]
                                                      videoSize:[self videoSize]];
    
    CGPoint position = toolLayer.position;
    position = fromPoint;
    toolLayer.position = position;
    
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:toolLayer
                                                           timeRange:timeRange];
    
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], timeRange.duration.timescale);
    personObj.appear = [[LBAlphaTransitionObj alloc] initWithFromValue:@0
                                                               toValue:@1
                                                          durationTime:transitionTime];
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    
    NSArray *positions = @[
                           [NSValue valueWithCGPoint:fromPoint],
                           [NSValue valueWithCGPoint:toPoint],
                           [NSValue valueWithCGPoint:fromPoint],
                           [NSValue valueWithCGPoint:toPoint]
                           ];
    
    
    CMTime bStartTime = CMTimeAdd(transitionTime, transitionTime);
    CMTime bDurationTime = CMTimeSubtract(CMTimeSubtract(CMTimeSubtract(timeRange.duration, transitionTime), transitionTime), transitionTime);
    CMTimeRange bTimeRange = CMTimeRangeMake(bStartTime, bDurationTime);
    LBMoveBehaviorObj *moveBehavior = [[LBMoveBehaviorObj alloc] initWithPositions:positions timeRange:bTimeRange];
    moveBehavior.extendForwards = YES;
    moveBehavior.timingFunctionNames = @[
                                         kCAMediaTimingFunctionEaseIn,
                                         kCAMediaTimingFunctionLinear,
                                         kCAMediaTimingFunctionEaseOut
                                         ];
    
    //Custom Behavior
    /*
    LBCustomBehaviorObj *customBehavior = [LBCustomBehaviorObj behaviorWithBlock:^(CALayer *personLayer, CALayer *sceneLayer) {
        CGSize originSize = toolLayer.bounds.size;
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
        animation.values = @[
                             [NSValue valueWithCGRect:CGRectMake(0, 0, originSize.width, originSize.height)],
                             [NSValue valueWithCGRect:CGRectMake(0, 0, originSize.width + 100, originSize.height + 100)],
                             [NSValue valueWithCGRect:CGRectMake(0, 0, originSize.width, originSize.height)],
                             [NSValue valueWithCGRect:CGRectMake(0, 0, originSize.width + 100, originSize.height + 100)]
                             ];
        animation.beginTime = 0;
        animation.duration = CMTimeGetSeconds(bDurationTime);
        animation.keyTimes = @[@0,@(1/3.f),@(2/3.f),@1];
        animation.timingFunctions = @[
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                      ];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
     
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 0, 1)];
        transformAnimation.beginTime = 0;
        transformAnimation.duration = CMTimeGetSeconds(bDurationTime);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.beginTime = 2.5 + [self normalTransitionTime] + CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(bStartTime);
        animationGroup.duration = CMTimeGetSeconds(bDurationTime);
        animationGroup.animations = @[animation, transformAnimation];
        
        [personLayer addAnimation:animationGroup forKey:nil];
    }];
    */
    
    personObj.behaviors = @[moveBehavior];
    
    return personObj;
}

#pragma mark - Compare Scene
+ (LBSceneObj *)createCompareSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime appearTransitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale);
    sceneObj.appear = [[LBColorMaskTransitionObj alloc] initWithFromValue:[UIColor whiteColor]
                                                                  toValue:nil
                                                             durationTime:appearTransitionTime];
    CMTime disAppearTransitionTime = CMTimeMakeWithSeconds([self longTransitionTime], durationTime.timescale);
    sceneObj.disappear = [[LBContentsMaskTransitionObj alloc] initWithFromValue:[self compareImage]
                                                                        toValue:[self blurCompareImage]
                                                                   durationTime:disAppearTransitionTime];
    
    CMTime personDurationTime = CMTimeSubtract(durationTime, disAppearTransitionTime);
    CMTimeRange personTimeRange = CMTimeRangeMake(kCMTimeZero, personDurationTime);
    
    LBPersonObj *compareImagesPersonObj = [self createCompareImagesPersonWithTimeRange:personTimeRange];
    LBPersonObj *detailPersonObj = [self createDetailPersonWithTimeRange:personTimeRange];
    sceneObj.persons = @[compareImagesPersonObj,detailPersonObj];
    return sceneObj;
}

+ (LBPersonObj *)createCompareImagesPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *compareLayer = [LBLayerHelper compareLayerWithContents:[self compareImage]
                                                          videoSize:[self videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:compareLayer
                                                           timeRange:timeRange];
    
    return personObj;
}

+ (LBPersonObj *)createDetailPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *detailLayer = [LBLayerHelper detailLayerWithDetail:[self detail]
                                                      videoSize:[self videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:detailLayer
                                                           timeRange:timeRange];
    
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], timeRange.duration.timescale);
    personObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromValue:@1
                                                                  toValue:@0
                                                             durationTime:transitionTime];
    
    return personObj;
}

#pragma mark - Products Scene
+ (LBSceneObj *)createProductsSceneWithDurationTime:(CMTime)durationTime {
    LBSceneObj *sceneObj = [[LBSceneObj alloc] initWithDurationTime:durationTime];
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale);
    sceneObj.disappear = [[LBColorMaskTransitionObj alloc] initWithFromValue:nil
                                                                     toValue:[UIColor whiteColor]
                                                                durationTime:transitionTime];
    
    LBPersonObj *backgroundPersonObj = [self createProductsBackgroundPersonWithTimeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    
    CMTime pageProductStartTime = CMTimeMakeWithSeconds([self normalTransitionTime], durationTime.timescale);
    CMTime pageProductDurationTime = CMTimeSubtract(durationTime, CMTimeMakeWithSeconds([self normalTransitionTime]*2, durationTime.timescale));
    CMTimeRange pageProductTimeRange = CMTimeRangeMake(pageProductStartTime, pageProductDurationTime);
    LBPersonObj *pageProductPersonObj = [self createPageProductPersonWithTimeRange:pageProductTimeRange];
    sceneObj.persons = @[backgroundPersonObj,pageProductPersonObj];
    
    return sceneObj;
}

+ (LBPersonObj *)createProductsBackgroundPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *compareLayer = [LBLayerHelper compareLayerWithContents:[self blurCompareImage]
                                                          videoSize:[self videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:compareLayer
                                                           timeRange:timeRange];
    
    return personObj;
}

+ (LBPersonObj *)createPageProductPersonWithTimeRange:(CMTimeRange)timeRange {
    CALayer *productLayer = [LBLayerHelper productLayerWithProducts:[self products]
                                                          videoSize:[self videoSize]];
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:productLayer
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], timeRange.duration.timescale);
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
    CALayer *watermarkLayer = [LBLayerHelper watermarkLayerWithTitle:[self title]
                                                            subTitle:[self subTitle]
                                                              author:[self author]
                                                                sign:[self sign]
                                                               color:color
                                                           videoSize:[self videoSize]];
    
    LBPersonObj *personObj = [[LBPersonObj alloc] initWithAppearance:watermarkLayer
                                                           timeRange:timeRange];
    CMTime transitionTime = CMTimeMakeWithSeconds([self normalTransitionTime], timeRange.duration.timescale);
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
    LBVideoEnvironmentObj *videoEnvironmentObj = [[LBVideoEnvironmentObj alloc] initWithVideoURL:[NSURL fileURLWithPath:[self videoPath]] backgroundColor:[UIColor whiteColor]];
    videoEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, totalVideoTime);
    
    return videoEnvironmentObj;
}

+ (LBAudioEnvironmentObj *)createAudioEnvironmentWithTotalVideoTime:(CMTime)totalVideoTime {
    LBAudioEnvironmentObj *audioEnvironmentObj = [[LBAudioEnvironmentObj alloc] initWithAudioURL:[NSURL fileURLWithPath:[self audioPath]]];
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
