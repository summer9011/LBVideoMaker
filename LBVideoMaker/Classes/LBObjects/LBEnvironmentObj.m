//
//  LBEnvironmentObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBEnvironmentObj.h"

@implementation LBEnvironmentObj

@synthesize timeRange;
@synthesize absoluteStartTime;

@synthesize appear = _appear;
@synthesize disappear = _disappear;

@synthesize nextEnvironment;

#pragma mark - Getting

- (CMTime)absoluteStartTime {
    return self.timeRange.start;
}

#pragma mark - Setting

- (void)setAppear:(id<LBTransitionProtocol>)appear {
    _appear = appear;
    appear.contenter = self;
    appear.timeRange = CMTimeRangeMake(kCMTimeZero, appear.timeRange.duration);
}

- (void)setDisappear:(id<LBTransitionProtocol>)disappear {
    _disappear = disappear;
    disappear.contenter = self;
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