//
//  LBEnvironmentObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"

@interface LBEnvironmentObj : LBBaseObj <LBEnvironmentProtocol>

@end

@interface LBAudioEnvironmentObj : LBEnvironmentObj <LBAudioEnvironmentProtocol>

@property (nonatomic, assign, readonly) CMTimeRange audioTimeRange;

- (instancetype)initWithAudioURL:(NSURL *)audioURL;

@end

@interface LBVideoEnvironmentObj : LBEnvironmentObj <LBVideoEnvironmentProtocol>

@property (nonatomic, assign, readonly) CMTimeRange videoTimeRange;

- (instancetype)initWithVideoURL:(NSURL *)videoURL
                 backgroundColor:(UIColor *)backgroundColor;

@end
