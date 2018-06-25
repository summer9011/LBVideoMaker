//
//  LBBehaviorObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"
#import "LBBehaviorProtocol.h"

@interface LBBehaviorObj : LBBaseObj <LBBehaviorProtocol>

@end

@interface LBContentsAnimationBehaviorObj : LBBehaviorObj <LBContentsAnimationBehaviorProtocol>

- (instancetype)initWithImages:(NSArray<UIImage *> *)images timeRange:(CMTimeRange)timeRange;

@end
