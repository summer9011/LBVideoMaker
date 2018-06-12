//
//  LBEnvironmentProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"

@protocol LBEnvironmentProtocol <NSObject, LBTimeProtocol>
@end

@protocol LBBackgroundAudioEnvironmentProtocol <LBEnvironmentProtocol>

@property (nonatomic, strong) NSURL *audioURL;

@end

@protocol LBBackgroundVideoEnvironmentProtocol <LBEnvironmentProtocol>

@property (nonatomic, strong) NSURL *videoURL;

@end
