//
//  LBPersonObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBPersonObj.h"
#import "LBSceneProtocol.h"

@implementation LBPersonObj

@synthesize timeRange;
@synthesize absoluteUsableTimeRange;
@synthesize absoluteStartTime;

@synthesize appearance;

@synthesize behaviors = _behaviors;

@synthesize appear = _appear;
@synthesize disappear = _disappear;

@synthesize contentScene;

- (instancetype)initWithAppearance:(CALayer *)appearance
                         timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.appearance = appearance;
        self.timeRange = timeRange;
    }
    return self;
}

#pragma mark - Getting

- (CMTimeRange)absoluteUsableTimeRange {
    CMTime startTime = self.absoluteStartTime;
    if (self.appear) {
        startTime = CMTimeAdd(self.appear.timeRange.duration, startTime);
    }
    CMTime endTime = CMTimeAdd(self.absoluteStartTime, self.timeRange.duration);
    if (self.disappear) {
        endTime = CMTimeSubtract(endTime, self.disappear.timeRange.duration);
    }
    return CMTimeRangeFromTimeToTime(startTime, endTime);
}

- (CMTime)absoluteStartTime {
    CMTime startTime = self.timeRange.start;
    if (self.contentScene) {
        startTime = CMTimeAdd(self.contentScene.absoluteStartTime, startTime);
    }
    return startTime;
}

#pragma mark - Setting

- (void)setBehaviors:(NSArray<id<LBBehaviorProtocol>> *)behaviors {
    _behaviors = behaviors;
    [behaviors enumerateObjectsUsingBlock:^(id<LBBehaviorProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentPerson = self;
    }];
}

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
