//
//  LBVideoObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBVideoObj.h"

@implementation LBVideoObj

@synthesize framePerSecond = _framePerSecond;
@synthesize totalVideoTime;

@synthesize environments;
@synthesize scenes = _scenes;

- (instancetype)initWithFramePerSecond:(int32_t)framePerSecond {
    if (self = [super init]) {
        _framePerSecond = framePerSecond;
    }
    return self;
}

- (CMTime)getSceneRelationTimeWithScene:(id<LBSceneProtocol>)scene {
    CMTime sceneTime = scene.timeRange.duration;
    if (scene.nextScene) {
        CMTime nextSceneTime = [self getSceneRelationTimeWithScene:scene.nextScene];
        sceneTime = CMTimeAdd(sceneTime, nextSceneTime);
    }
    return sceneTime;
}

- (void)addContentVideoToScene:(id<LBSceneProtocol>)scene {
    scene.contentVideo = self;
    if (scene.nextScene) {
        [self addContentVideoToScene:scene.nextScene];
    }
}

#pragma mark - Getting

- (CMTime)totalVideoTime {
    __block CMTime totalVideoTime = kCMTimeZero;
    [self.scenes enumerateObjectsUsingBlock:^(id<LBSceneProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            totalVideoTime = [self getSceneRelationTimeWithScene:obj];
        } else {
            CMTime sceneTime = [self getSceneRelationTimeWithScene:obj];
            totalVideoTime = CMTimeAdd(totalVideoTime, sceneTime);
        }
    }];
    return totalVideoTime;
}

#pragma mark - Setting

- (void)setScenes:(NSArray<id<LBSceneProtocol>> *)scenes {
    _scenes = scenes;
    [scenes enumerateObjectsUsingBlock:^(id<LBSceneProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addContentVideoToScene:obj];
    }];
}

@end
