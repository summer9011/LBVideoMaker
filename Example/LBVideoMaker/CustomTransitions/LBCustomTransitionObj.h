//
//  LBCustomTransitionObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/29.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LBVideoMaker/LBTransitionProtocol.h>

@interface LBCustomTransitionObj : NSObject <LBTransitionProtocol>

+ (LBCustomTransitionObj *)transitionWithBlock:(void(^)(CALayer *layer, CALayer *parentLayer, CFTimeInterval keepTime))block;

@end
