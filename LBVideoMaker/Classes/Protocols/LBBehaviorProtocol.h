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

@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, strong) NSArray<NSString *> *timingFunctionNames;

@property (nonatomic, weak) id<LBBehaviorProtocol> nextBehavior;

@property (nonatomic, weak) id<LBPersonProtocol> contentPerson;

@end

@protocol LBContentsGradientBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<UIImage *> *images;

@end

@protocol LBMovesBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<NSValue *> *positions;
@property (nonatomic, strong) UIBezierPath *path;

@end
