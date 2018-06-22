//
//  LBDefaultTransitionObj.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/22.
//

#import <Foundation/Foundation.h>
#import "LBTransitionObj.h"

@interface LBDefaultTransitionObj : LBAlphaTransitionObj

- (instancetype)initWithFromAlpha:(CGFloat)fromAlpha
                          toAlpha:(CGFloat)toAlpha
                        contenter:(id<LBTimeProtocol>)contenter
                        timeRange:(CMTimeRange)timeRange;

@end
