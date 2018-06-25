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

@synthesize timeRange;
@synthesize absoluteUsableTimeRange;
@synthesize absoluteStartTime;

@synthesize repeatCount;
@synthesize nextBehavior;
@synthesize contentPerson;

@end


@implementation LBContentsAnimationBehaviorObj

@synthesize images;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.images = images;
        self.timeRange = timeRange;
    }
    return self;
}

#pragma mark - Getting

- (CMTimeRange)absoluteUsableTimeRange {
    
}

- (CMTime)absoluteStartTime {
    CMTime startTime = self.timeRange.start;
    if (self.contentPerson) {
        startTime = CMTimeAdd(self.contentPerson.absoluteStartTime, startTime);
    }
    return startTime;
}

@end
