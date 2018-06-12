//
//  LBMaskTransitionProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTransitionProtocol.h"

@protocol LBMaskTransitionProtocol <LBTransitionProtocol>
@end

@protocol LBColorMaskTransitionProtocol <LBMaskTransitionProtocol>

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;

@end
