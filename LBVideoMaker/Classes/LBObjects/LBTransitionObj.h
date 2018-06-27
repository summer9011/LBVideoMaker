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

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime;

@end

@interface LBVolumeTransitionObj : LBTransitionObj <LBVolumeTransitionProtocol>
@end

@interface LBAlphaTransitionObj : LBTransitionObj <LBAlphaTransitionProtocol>
@end

@interface LBMaskTransitionObj : LBTransitionObj <LBMaskTransitionProtocol>

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime
                         isAppear:(BOOL)isAppear;

@end

@interface LBColorMaskTransitionObj : LBMaskTransitionObj <LBColorMaskTransitionProtocol>
@end

@interface LBContentsMaskTransitionObj : LBMaskTransitionObj <LBContentsMaskTransitionProtocol>
@end


@interface LBDefaultTransitionObj : LBAlphaTransitionObj

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                             host:(id<LBTimeProtocol>)host
                        timeRange:(CMTimeRange)timeRange;

@end
