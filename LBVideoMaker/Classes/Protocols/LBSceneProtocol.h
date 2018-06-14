//
//  LBSceneProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"
#import "LBTransitionProtocol.h"
#import "LBPersonProtocol.h"

@protocol LBSceneProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, strong) NSArray<id<LBPersonProtocol>> *persons;

@property (nonatomic, strong) id<LBTransitionProtocol> appear;
@property (nonatomic, strong) id<LBTransitionProtocol> disappear;

@property (nonatomic, strong) id<LBSceneProtocol> nextScene;

@end
