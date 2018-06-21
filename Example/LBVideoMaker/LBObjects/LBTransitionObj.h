//
//  LBTransitionObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"

@interface LBTransitionObj : LBBaseObj <LBTransitionProtocol>

@end

@interface LBVolumeTransitionObj : LBTransitionObj <LBVolumeTransitionProtocol>

- (instancetype)initWithFromVolume:(CGFloat)fromVolume
                          toVolume:(CGFloat)toVolume
                         timeRange:(CMTimeRange)timeRange;

@end

@interface LBAlphaTransitionObj : LBTransitionObj <LBAlphaTransitionProtocol>

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                        timeRange:(CMTimeRange)timeRange;

@end

@interface LBMaskTransitionObj : LBTransitionObj <LBMaskTransitionProtocol>

@end

@interface LBColorMaskTransitionObj : LBMaskTransitionObj <LBColorMaskTransitionProtocol>

@end
