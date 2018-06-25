//
//  LBBehaviorProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"

@protocol LBPersonProtocol;

@protocol LBBehaviorProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, assign) BOOL repeatCount;

@property (nonatomic, weak) id<LBBehaviorProtocol> nextBehavior;

@property (nonatomic, weak) id<LBPersonProtocol> contentPerson;

@end

@protocol LBContentsAnimationBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<UIImage *> *images;

@end
