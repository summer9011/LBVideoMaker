//
//  LBTransitionObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"
#import "LBTransitionProtocol.h"

@interface LBTransitionObj : LBBaseObj <LBTransitionProtocol>

@end

@interface LBVolumeTransitionObj : LBTransitionObj <LBVolumeTransitionProtocol>

- (instancetype)initWithFromVolume:(CGFloat)fromVolume
                          toVolume:(CGFloat)toVolume
                      durationTime:(CMTime)durationTime;

@end

@interface LBAlphaTransitionObj : LBTransitionObj <LBAlphaTransitionProtocol>

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                     durationTime:(CMTime)durationTime;

@end

@interface LBMaskTransitionObj : LBTransitionObj <LBMaskTransitionProtocol>

@end

@interface LBColorMaskTransitionObj : LBMaskTransitionObj <LBColorMaskTransitionProtocol>

- (instancetype)initWithFromColor:(UIColor *)fromColor
                          toColor:(UIColor *)toColor
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear;

@end
