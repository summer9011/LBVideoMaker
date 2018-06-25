//
//  LBBehaviorObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBehaviorObj.h"
#import "LBPersonProtocol.h"

@implementation LBBehaviorObj

@synthesize timeRange = _timeRange;
@synthesize absoluteUsableTimeRange;
@synthesize absoluteStartTime;

@synthesize repeatCount;
@synthesize nextBehavior = _nextBehavior;
@synthesize contentPerson;

- (instancetype)init {
    if (self = [super init]) {
        self.repeatCount = 1;
    }
    return self;
}

- (void)resetNextBehaviorTimeRange:(id<LBBehaviorProtocol>)nextBehavior {
    nextBehavior.timeRange = CMTimeRangeMake(CMTimeRangeGetEnd(self.timeRange), nextBehavior.timeRange.duration);
}

#pragma mark - Getting

- (CMTimeRange)absoluteUsableTimeRange {
    return CMTimeRangeMake(self.absoluteStartTime, self.timeRange.duration);
}

- (CMTime)absoluteStartTime {
    CMTime startTime = self.timeRange.start;
    if (self.contentPerson) {
        startTime = CMTimeAdd(self.contentPerson.absoluteStartTime, startTime);
    }
    return startTime;
}

#pragma mark - Setting

- (void)setTimeRange:(CMTimeRange)timeRange {
    _timeRange = timeRange;
    if (self.nextBehavior) {
        [self resetNextBehaviorTimeRange:self.nextBehavior];
    }
}

- (void)setNextBehavior:(id<LBBehaviorProtocol>)nextBehavior {
    _nextBehavior = nextBehavior;
    [self resetNextBehaviorTimeRange:nextBehavior];
}

@end


@implementation LBContentsGradientBehaviorObj

@synthesize images;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.images = images;
        self.timeRange = timeRange;
    }
    return self;
}

@end

@implementation LBMovesBehaviorObj


@end
