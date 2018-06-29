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
@property (nonatomic, assign) BOOL autoreverses;
@property (nonatomic, strong) NSArray<NSString *> *timingFunctionNames;

@property (nonatomic, assign) BOOL extendBackwards;
@property (nonatomic, assign) BOOL extendForwards;

@property (nonatomic, strong) id<LBBehaviorProtocol> nextBehavior;

@property (nonatomic, strong) void(^animationBlock)(CALayer *personLayer, CALayer *sceneLayer);

@property (nonatomic, weak) id<LBPersonProtocol> contentPerson;

@end

@protocol LBContentGradientBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<UIImage *> *images;

@end

@protocol LBMoveBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<NSValue *> *positions;
@property (nonatomic, strong) UIBezierPath *path;

@end

@protocol LBZoomBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSArray<NSValue *> *zooms;

@end

@protocol LBTransformBehaviorProtocol <LBBehaviorProtocol>

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSArray<NSValue *> *transforms;

@end
