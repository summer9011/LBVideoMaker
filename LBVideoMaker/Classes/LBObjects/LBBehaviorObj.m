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
@synthesize absoluteStartTime;

@synthesize repeatCount;
@synthesize autoreverses;
@synthesize timingFunctionNames;

@synthesize extendBackwards;
@synthesize extendForwards;

@synthesize nextBehavior = _nextBehavior;
@synthesize contentPerson;

- (instancetype)init {
    if (self = [super init]) {
        self.repeatCount = 1;
        self.autoreverses = NO;
        self.timingFunctionNames = nil;
        self.extendBackwards = NO;
        self.extendForwards = NO;
    }
    return self;
}

- (void)resetNextBehaviorTimeRange:(id<LBBehaviorProtocol>)nextBehavior {
    nextBehavior.timeRange = CMTimeRangeMake(CMTimeRangeGetEnd(self.timeRange), nextBehavior.timeRange.duration);
}

#pragma mark - Getting

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

@synthesize positions;
@synthesize path;

- (instancetype)initWithPositions:(NSArray<NSValue *> *)positions timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.positions = positions;
        self.timeRange = timeRange;
    }
    return self;
}

- (instancetype)initWithPath:(UIBezierPath *)path timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.path = path;
        self.timeRange = timeRange;
    }
    return self;
}

@end
