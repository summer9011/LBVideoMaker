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

@interface LBContentsGradientBehaviorObj : LBBehaviorObj <LBContentsGradientBehaviorProtocol>

- (instancetype)initWithImages:(NSArray<UIImage *> *)images timeRange:(CMTimeRange)timeRange;

@end

@interface LBMovesBehaviorObj : LBBehaviorObj <LBMovesBehaviorProtocol>

- (instancetype)initWithPositions:(NSArray<NSValue *> *)positions timeRange:(CMTimeRange)timeRange;
- (instancetype)initWithPath:(UIBezierPath *)path timeRange:(CMTimeRange)timeRange;

@end
