//
//  LBScreenplayObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBScreenplayObj.h"

@implementation LBScreenplayObj

- (instancetype)init {
    if (self = [super init]) {
        self.screenplayName = [[NSUUID UUID].UUIDString lowercaseString];
        self.videoSize = CGSizeMake(720, 720);
        self.frames = 60;
        self.customBackgroundAudio = NO;
        self.customBackgroundVideo = NO;
    }
    return self;
}

@end
