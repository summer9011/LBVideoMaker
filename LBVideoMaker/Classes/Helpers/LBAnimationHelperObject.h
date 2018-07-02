//
//  LBAnimationHelperObject.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/7/2.
//

#import <Foundation/Foundation.h>
#import "LBTransitionProtocol.h"
#import "LBBehaviorProtocol.h"

@interface LBAnimationHelperObject : NSObject

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) NSTimeInterval beginTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, assign) BOOL autoreverses;
@property (nonatomic, strong) NSArray<NSString *> *timingFunctionNames;
@property (nonatomic, assign) BOOL forwords;
@property (nonatomic, assign) BOOL backwards;

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *keyTimes;
@property (nonatomic, strong, readonly) NSArray<CAMediaTimingFunction *> *timingFunctions;

- (instancetype)initWithTransition:(id<LBTransitionProtocol>)transition;
- (instancetype)initWithBehavior:(id<LBBehaviorProtocol>)behavior;

@end
