//
//  LBSceneObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBSceneObj.h"

@implementation LBSceneObj

@synthesize timeRange = _timeRange;

@synthesize sortType;

@synthesize persons;

@synthesize appear = _appear;
@synthesize disappear = _disappear;

@synthesize nextScene = _nextScene;

@synthesize contentVideo;

- (instancetype)initWithDurationTime:(CMTime)durationTime {
    if (self = [super init]) {
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
        self.sortType = LBSceneSortDefault;
    }
    return self;
}

- (instancetype)initWithDurationTime:(CMTime)durationTime sortType:(LBSceneSortType)sortType {
    if (self = [super init]) {
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
        self.sortType = sortType;
    }
    return self;
}

- (void)resetNextSceneTimeRange:(id<LBSceneProtocol>)nextScene {
    CMTime nextSceneStartTime = CMTimeAdd(self.timeRange.start, self.timeRange.duration);
    nextScene.timeRange = CMTimeRangeMake(nextSceneStartTime, nextScene.timeRange.duration);
}

#pragma mark - Setting

- (void)setTimeRange:(CMTimeRange)timeRange {
    _timeRange = timeRange;
    
    if (self.nextScene) {
        [self resetNextSceneTimeRange:self.nextScene];
    }
}

- (void)setNextScene:(id<LBSceneProtocol>)nextScene {
    _nextScene = nextScene;
    [self resetNextSceneTimeRange:nextScene];
}

- (void)setAppear:(id<LBTransitionProtocol>)appear {
    _appear = appear;
    appear.timeRange = CMTimeRangeMake(kCMTimeZero, appear.timeRange.duration);
}

- (void)setDisappear:(id<LBTransitionProtocol>)disappear {
    _disappear = disappear;
    CMTime startTime = CMTimeSubtract(self.timeRange.duration, disappear.timeRange.duration);
    disappear.timeRange = CMTimeRangeMake(startTime, disappear.timeRange.duration);
}

@end
