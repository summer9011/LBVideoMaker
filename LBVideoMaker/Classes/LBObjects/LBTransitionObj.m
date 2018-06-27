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
@synthesize absoluteStartTime;

@synthesize fromValue;
@synthesize toValue;

@synthesize host;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime {
    if (self = [super init]) {
        self.fromValue = fromValue;
        self.toValue = toValue;
        self.timeRange = CMTimeRangeMake(kCMTimeZero, durationTime);
    }
    return self;
}

#pragma mark - Getting

- (CMTime)absoluteStartTime {
    CMTime startTime = self.timeRange.start;
    if (self.host) {
        startTime = CMTimeAdd(self.host.absoluteStartTime, startTime);
    }
    return startTime;
}

@end

@implementation LBVolumeTransitionObj

@synthesize fromVolume = _fromVolume;
@synthesize toVolume = _toVolume;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime {
    if (self  = [super initWithFromValue:fromValue
                                 toValue:toValue
                            durationTime:durationTime]) {
        _fromVolume = [(NSNumber *)fromValue floatValue];
        _toVolume = [(NSNumber *)toValue floatValue];
    }
    return self;
}

@end

@implementation LBAlphaTransitionObj

@synthesize fromAlpha = _fromAlpha;
@synthesize toAlpha = _toAlpha;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime {
    if (self  = [super initWithFromValue:fromValue
                                 toValue:toValue
                            durationTime:durationTime]) {
        _fromAlpha = [(NSNumber *)fromValue floatValue];
        _toAlpha = [(NSNumber *)toValue floatValue];
    }
    return self;
}

@end

@implementation LBMaskTransitionObj

@synthesize isAppear = _isAppear;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear {
    if (self  = [super initWithFromValue:fromValue
                                 toValue:toValue
                            durationTime:durationTime]) {
        _isAppear = isAppear;
    }
    return self;
}

@end

@implementation LBColorMaskTransitionObj

@synthesize fromColor = _fromColor;
@synthesize toColor = _toColor;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear {
    if (self  = [super initWithFromValue:fromValue
                                 toValue:toValue
                            durationTime:durationTime
                                isAppear:isAppear]) {
        _fromColor = fromValue;
        _toColor = toValue;
    }
    return self;
}

@end

@implementation LBContentsMaskTransitionObj

@synthesize fromImage = _fromImage;
@synthesize toImage = _toImage;

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear {
    if (self  = [super initWithFromValue:fromValue
                                 toValue:toValue
                            durationTime:durationTime
                                isAppear:isAppear]) {
        _fromImage = fromValue;
        _toImage = toValue;
    }
    return self;
}

@end




@implementation LBDefaultTransitionObj

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                             host:(id<LBTimeProtocol>)host
                        timeRange:(CMTimeRange)timeRange {
    if (self = [super initWithFromValue:@(fromAlpha)
                                toValue:@(toAlpha)
                           durationTime:timeRange.duration]) {
        self.host = host;
        self.timeRange = timeRange;
    }
    return self;
}

@end
