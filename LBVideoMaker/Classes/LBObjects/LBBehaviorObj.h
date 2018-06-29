//
//  LBBehaviorObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBBehaviorProtocol.h"

@interface LBBehaviorObj : NSObject <LBBehaviorProtocol>

@end

@interface LBContentGradientBehaviorObj : LBBehaviorObj <LBContentGradientBehaviorProtocol>

- (instancetype)initWithImages:(NSArray<UIImage *> *)images timeRange:(CMTimeRange)timeRange;

@end

@interface LBMoveBehaviorObj : LBBehaviorObj <LBMoveBehaviorProtocol>

- (instancetype)initWithPositions:(NSArray<NSValue *> *)positions timeRange:(CMTimeRange)timeRange;
- (instancetype)initWithPath:(UIBezierPath *)path timeRange:(CMTimeRange)timeRange;

@end

@interface LBZoomBehaviorObj : LBBehaviorObj <LBZoomBehaviorProtocol>

- (instancetype)initWithZooms:(NSArray<NSValue *> *)zooms timeRange:(CMTimeRange)timeRange;

@end

@interface LBTransformBehaviorObj : LBBehaviorObj <LBTransformBehaviorProtocol>

- (instancetype)initWithKeyPath:(NSString *)keyPath transforms:(NSArray<NSValue *> *)transforms timeRange:(CMTimeRange)timeRange;

@end
