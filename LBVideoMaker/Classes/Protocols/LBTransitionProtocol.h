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

@end

@protocol LBVolumeTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign, readonly) CGFloat fromVolume;
@property (nonatomic, assign, readonly) CGFloat toVolume;

@end

@protocol LBAlphaTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign, readonly) CGFloat fromAlpha;
@property (nonatomic, assign, readonly) CGFloat toAlpha;

@end

@protocol LBMaskTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign) BOOL isAppear;

@end

@protocol LBColorMaskTransitionProtocol <LBMaskTransitionProtocol>

@property (nonatomic, strong, readonly) UIColor *fromColor;
@property (nonatomic, strong, readonly) UIColor *toColor;

@end

@protocol LBContentsMaskTransitionProtocol <LBMaskTransitionProtocol>

@property (nonatomic, strong, readonly) UIImage *fromImage;
@property (nonatomic, strong, readonly) UIImage *toImage;

@end