//
//  LBPersonProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"
#import "LBBehaviorProtocol.h"
#import "LBTransitionProtocol.h"

@protocol LBSceneProtocol;

@protocol LBPersonProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, strong) CALayer *appearance;

@property (nonatomic, strong) NSArray<id<LBBehaviorProtocol>> *behaviors;

@property (nonatomic, strong) id<LBTransitionProtocol> appear;
@property (nonatomic, strong) id<LBTransitionProtocol> disappear;

@property (nonatomic, weak) id<LBSceneProtocol> contentScene;

@end
