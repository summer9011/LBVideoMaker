//
//  LBBehaviorHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/25.
//

#import <Foundation/Foundation.h>
#import "LBBehaviorProtocol.h"

@interface LBBehaviorHelper : NSObject

+ (void)addBehavior:(id<LBBehaviorProtocol>)behavior
    withPersonLayer:(CALayer *)personLayer
       toSceneLayer:(CALayer *)sceneLayer;

@end
