//
//  LBEnvironmentObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBEnvironmentObj.h"

@implementation LBEnvironmentObj

@synthesize timeRange;

@synthesize appear;
@synthesize disappear;

@synthesize nextEnvironment;

@end

@implementation LBAudioEnvironmentObj

@synthesize audioURL;

- (instancetype)initWithAudioURL:(NSURL *)audioURL {
    if (self = [super init]) {
        self.audioURL = audioURL;
    }
    return self;
}

@end

@implementation LBVideoEnvironmentObj

@synthesize backgroundColor;
@synthesize videoURL;

- (instancetype)initWithVideoURL:(NSURL *)videoURL
                 backgroundColor:(UIColor *)backgroundColor {
    if (self = [super init]) {
        self.videoURL = videoURL;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

@end
