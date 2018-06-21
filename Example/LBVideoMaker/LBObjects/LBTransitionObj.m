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

@end

@implementation LBVolumeTransitionObj

@synthesize fromVolume;
@synthesize toVolume;

- (instancetype)initWithFromVolume:(CGFloat)fromVolume
                          toVolume:(CGFloat)toVolume
                         timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.fromVolume = fromVolume;
        self.toVolume = toVolume;
        self.timeRange = timeRange;
    }
    return self;
}

@end

@implementation LBAlphaTransitionObj

@synthesize fromAlpha;
@synthesize toAlpha;

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                        timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.fromAlpha = fromAlpha;
        self.toAlpha = toAlpha;
        self.timeRange = timeRange;
    }
    return self;
}

@end

@implementation LBMaskTransitionObj

@end

@implementation LBColorMaskTransitionObj

@synthesize fromColor;
@synthesize toColor;

- (instancetype)initWithFromColor:(UIColor *)fromColor
                          toColor:(UIColor *)toColor
                        timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.fromColor = fromColor;
        self.toColor = toColor;
        self.timeRange = timeRange;
    }
    return self;
}

@end
