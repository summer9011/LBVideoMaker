//
//  LBAnimationHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/15.
//

#import <Foundation/Foundation.h>
#import "LBAnimationHelperObject.h"

@interface LBAnimationHelper : NSObject

+ (CAAnimation *)animationWithObject:(LBAnimationHelperObject *)object;

@end
