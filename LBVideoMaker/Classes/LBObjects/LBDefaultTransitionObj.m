//
//  LBDefaultTransitionObj.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/22.
//

#import "LBDefaultTransitionObj.h"

@implementation LBDefaultTransitionObj

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                        contenter:(id<LBTimeProtocol>)contenter
                        timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        self.fromAlpha = fromAlpha;
        self.toAlpha = toAlpha;
        self.contenter = contenter;
        self.timeRange = timeRange;
    }
    return self;
}

@end
