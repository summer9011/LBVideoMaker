//
//  LBTransitionObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBTransitionProtocol.h"

@interface LBTransitionObj : NSObject <LBTransitionProtocol>

- (instancetype)initWithFromValue:(id)fromValue
                          toValue:(id)toValue
                     durationTime:(CMTime)durationTime;

@end

@interface LBVolumeTransitionObj : LBTransitionObj <LBVolumeTransitionProtocol>
@end

@interface LBAlphaTransitionObj : LBTransitionObj <LBAlphaTransitionProtocol>
@end

@interface LBColorMaskTransitionObj : LBTransitionObj <LBColorMaskTransitionProtocol>
@end

@interface LBContentsMaskTransitionObj : LBTransitionObj <LBContentsMaskTransitionProtocol>
@end


@interface LBDefaultTransitionObj : LBAlphaTransitionObj

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                             host:(id<LBTimeProtocol>)host
                        timeRange:(CMTimeRange)timeRange;

@end
