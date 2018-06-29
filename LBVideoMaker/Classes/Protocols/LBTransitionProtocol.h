//
//  LBTransitionProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"

@protocol LBTransitionProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@property (nonatomic, weak) id<LBTimeProtocol> host;

@property (nonatomic, strong) void(^animationBlock)(CALayer *layer, CALayer *parentLayer, CFTimeInterval keepTime);

@end

@protocol LBVolumeTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign, readonly) CGFloat fromVolume;
@property (nonatomic, assign, readonly) CGFloat toVolume;

@end

@protocol LBAlphaTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign, readonly) CGFloat fromAlpha;
@property (nonatomic, assign, readonly) CGFloat toAlpha;

@end

@protocol LBColorMaskTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, strong, readonly) UIColor *fromColor;
@property (nonatomic, strong, readonly) UIColor *toColor;

@end

@protocol LBContentsMaskTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, strong, readonly) UIImage *fromImage;
@property (nonatomic, strong, readonly) UIImage *toImage;

@end
