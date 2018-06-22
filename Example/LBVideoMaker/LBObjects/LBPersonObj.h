//
//  LBPersonObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"

@interface LBPersonObj : LBBaseObj <LBPersonProtocol>

- (instancetype)initWithAppearance:(CALayer *)appearance
                       percentRect:(CGRect)percentRect
                         timeRange:(CMTimeRange)timeRange;

- (instancetype)initWithAppearance:(CALayer *)appearance
                     percentCenter:(CGPoint)percentCenter
                       percentSize:(CGSize)percentSize
                         timeRange:(CMTimeRange)timeRange;

- (instancetype)initWithAppearance:(CALayer *)appearance
                     percentCenter:(CGPoint)percentCenter
                      specificSize:(CGSize)specificSize
                         timeRange:(CMTimeRange)timeRange;

@end
