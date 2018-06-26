//
//  LBTransitionObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBTransitionObj.h"

@implementation LBTransitionObj

@synthesize timeRange;
@synthesize absoluteUsableTimeRange;
@synthesize absoluteStartTime;

@synthesize contenter;

#pragma mark - Getting

- (CMTimeRange)absoluteUsableTimeRange {
    return CMTimeRangeMake(self.absoluteStartTime, self.timeRange.duration);
}

- (CMTime)absoluteStartTime {
    CMTime startTime = self.timeRange.start;
    if (self.contenter) {
        startTime = CMTimeAdd(self.contenter.absoluteStartTime, startTime);
    }
    return startTime;
}

@end

@implementation LBVolumeTransitionObj

@synthesize fromVolume;
@synthesize toVolume;

- (instancetype)initWithFromVolume:(CGFloat)fromVolume
                          toVolume:(CGFloat)toVolume
                      durationTime:(CMTime)durationTime {
    if (self = [super init]) {
        self.fromVolume = fromVolume;
        self.toVolume = toVolume;
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    }
    return self;
}

@end

@implementation LBAlphaTransitionObj

@synthesize fromAlpha;
@synthesize toAlpha;

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                     durationTime:(CMTime)durationTime {
    if (self = [super init]) {
        self.fromAlpha = fromAlpha;
        self.toAlpha = toAlpha;
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    }
    return self;
}

@end

@implementation LBMaskTransitionObj

@synthesize isAppear;

@end

@implementation LBColorMaskTransitionObj

@synthesize fromColor;
@synthesize toColor;

- (instancetype)initWithFromColor:(UIColor *)fromColor
                          toColor:(UIColor *)toColor
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear {
    if (self = [super init]) {
        self.fromColor = fromColor;
        self.toColor = toColor;
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
        self.isAppear = isAppear;
    }
    return self;
}

@end

@implementation LBContentsMaskTransitionObj

@synthesize fromImage;
@synthesize toImage;

- (instancetype)initWithFromImage:(UIImage *)fromImage
                          toImage:(UIImage *)toImage
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear {
    if (self = [super init]) {
        self.fromImage = fromImage;
        self.toImage = toImage;
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
        self.isAppear = isAppear;
    }
    return self;
}

@end
