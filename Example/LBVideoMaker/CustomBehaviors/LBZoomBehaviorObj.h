//
//  LBZoomBehaviorObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/28.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LBVideoMaker/LBBehaviorProtocol.h>

@interface LBZoomBehaviorObj : NSObject <LBBehaviorProtocol>

+ (LBZoomBehaviorObj *)animationWithBlock:(void(^)(CALayer *personLayer, CALayer *sceneLayer))block;

@end
