//
//  LBAlphaTransitionProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTransitionProtocol.h"

@protocol LBAlphaTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign) CGFloat fromAlpha;
@property (nonatomic, assign) CGFloat toAlpha;

@end
