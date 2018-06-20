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
        self.timeRange = timeRange;
        self.fromVolume = fromVolume;
        self.toVolume = toVolume;
    }
    return self;
}

@end

@implementation LBAlphaTransitionObj

@synthesize fromAlpha;
@synthesize toAlpha;

@end

@implementation LBMaskTransitionObj

@end

@implementation LBColorMaskTransitionObj

@synthesize fromColor;
@synthesize toColor;

@end
