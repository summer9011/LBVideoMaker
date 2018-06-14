//
//  LBPersonProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"
#import "LBPositionProtocol.h"
#import "LBBehaviorProtocol.h"
#import "LBTransitionProtocol.h"
#import "LBPersonAppearanceProtocol.h"

@protocol LBPersonProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, strong) id<LBPersonAppearanceProtocol> appearance;
@property (nonatomic, strong) NSArray<id<LBPositionProtocol>> *moves;
@property (nonatomic, strong) NSArray<id<LBBehaviorProtocol>> *behaviors;

@property (nonatomic, strong) id<LBTransitionProtocol> appear;
@property (nonatomic, strong) id<LBTransitionProtocol> disappear;

@end
