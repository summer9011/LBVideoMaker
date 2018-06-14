//
//  LBVideoProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBEnvironmentProtocol.h"
#import "LBSceneProtocol.h"

@protocol LBVideoProtocol <NSObject>

@property (nonatomic, assign) int32_t frames;   //30fps

@property (nonatomic, strong) NSSet<id<LBEnvironmentProtocol>> *environments;
@property (nonatomic, strong) NSArray<id<LBSceneProtocol>> *scenes;

@end
