//
//  LBAnimationHelperObject.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/7/2.
//

#import "LBAnimationHelperObject.h"

@implementation LBAnimationHelperObject

- (instancetype)initWithTransition:(id<LBTransitionProtocol>)transition {
    if (self = [super init]) {
        self.repeatCount = 1;
        self.autoreverses = NO;
        self.timingFunctionNames = nil;
        self.backwards = NO;
        self.forwords = NO;
    }
    return self;
}

- (instancetype)initWithBehavior:(id<LBBehaviorProtocol>)behavior {
    if (self = [super init]) {
        self.repeatCount = behavior.repeatCount;
        self.autoreverses = behavior.autoreverses;
        self.timingFunctionNames = behavior.timingFunctionNames;
        self.backwards = behavior.extendForwards;
        self.forwords = behavior.extendForwards;
    }
    return self;
}

- (NSArray<NSNumber *> *)keyTimes {
    NSUInteger valuesCount = self.values.count;
    NSMutableArray<NSNumber *> *keyTimes = [NSMutableArray array];
    for (NSUInteger i = 0; i < valuesCount; i ++) {
        if (i == 0) {
            [keyTimes addObject:@0];
        } else {
            [keyTimes addObject:@(i/(CGFloat)(valuesCount - 1))];
        }
    }
    return keyTimes;
}

- (NSArray<CAMediaTimingFunction *> *)timingFunctions {
    NSMutableArray<CAMediaTimingFunction *> *timingFunctions = nil;
    if (self.timingFunctionNames) {
        [self.timingFunctionNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:obj];
            [timingFunctions addObject:timingFunction];
        }];
    }
    return timingFunctions;
}

@end
