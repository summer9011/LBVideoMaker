//
//  LBVideoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBVideoObj.h"

@implementation LBVideoObj

@synthesize frames;

@synthesize environments;
@synthesize scenes;

- (instancetype)init {
    if (self = [super init]) {
        self.frames = 30;
    }
    return self;
}

@end
