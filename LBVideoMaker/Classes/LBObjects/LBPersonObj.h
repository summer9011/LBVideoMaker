//
//  LBPersonObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBPersonProtocol.h"

@interface LBPersonObj : NSObject <LBPersonProtocol>

- (instancetype)initWithAppearance:(CALayer *)appearance
                         timeRange:(CMTimeRange)timeRange;

@end
