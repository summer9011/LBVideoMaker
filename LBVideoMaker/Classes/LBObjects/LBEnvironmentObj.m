//
//  LBEnvironmentObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBEnvironmentObj.h"

@implementation LBEnvironmentObj

@synthesize timeRange = _timeRange;
@synthesize absoluteStartTime;
@synthesize appear = _appear;
@synthesize disappear = _disappear;
@synthesize nextEnvironment = _nextEnvironment;

- (void)resetNextEnvironmentTimeRange:(id<LBEnvironmentProtocol>)nextEnvironment {
    nextEnvironment.timeRange = CMTimeRangeMake(CMTimeRangeGetEnd(self.timeRange), nextEnvironment.timeRange.duration);
}

#pragma mark - Getting

- (CMTime)absoluteStartTime {
    return self.timeRange.start;
}

#pragma mark - Setting

- (void)setTimeRange:(CMTimeRange)timeRange {
    _timeRange = timeRange;
    if (self.nextEnvironment) {
        [self resetNextEnvironmentTimeRange:self.nextEnvironment];
    }
}

- (void)setNextEnvironment:(id<LBEnvironmentProtocol>)nextEnvironment {
    _nextEnvironment = nextEnvironment;
    [self resetNextEnvironmentTimeRange:nextEnvironment];
}

- (void)setAppear:(id<LBTransitionProtocol>)appear {
    _appear = appear;
    appear.host = self;
    appear.timeRange = CMTimeRangeMake(kCMTimeZero, appear.timeRange.duration);
}

- (void)setDisappear:(id<LBTransitionProtocol>)disappear {
    _disappear = disappear;
    disappear.host = self;
    CMTime startTime = CMTimeSubtract(self.timeRange.duration, disappear.timeRange.duration);
    disappear.timeRange = CMTimeRangeMake(startTime, disappear.timeRange.duration);
}

@end

@implementation LBAudioEnvironmentObj

@synthesize audioURL;

- (instancetype)initWithAudioURL:(NSURL *)audioURL {
    if (self = [super init]) {
        self.audioURL = audioURL;
    }
    return self;
}

@end

@implementation LBVideoEnvironmentObj

@synthesize backgroundColor;
@synthesize videoURL;

- (instancetype)initWithVideoURL:(NSURL *)videoURL
                 backgroundColor:(UIColor *)backgroundColor {
    if (self = [super init]) {
        self.videoURL = videoURL;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

@end
