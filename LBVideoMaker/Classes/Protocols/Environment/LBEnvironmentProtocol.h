//
//  LBEnvironmentProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"
#import "LBTransitionProtocol.h"

@protocol LBEnvironmentProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, strong) id<LBTransitionProtocol> appear;
@property (nonatomic, strong) id<LBTransitionProtocol> disappear;

@property (nonatomic, strong) id<LBEnvironmentProtocol> nextEnvironment;

@end

@protocol LBAudioEnvironmentProtocol <LBEnvironmentProtocol>

@property (nonatomic, strong) NSURL *audioURL;

@end

@protocol LBVideoEnvironmentProtocol <LBEnvironmentProtocol>

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSURL *videoURL;

@end
