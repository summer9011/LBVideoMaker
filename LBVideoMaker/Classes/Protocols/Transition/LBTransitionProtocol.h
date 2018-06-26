//
//  LBTransitionProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"

@protocol LBTransitionProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, weak) id<LBTimeProtocol> contenter;

@end

@protocol LBVolumeTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign) CGFloat fromVolume;
@property (nonatomic, assign) CGFloat toVolume;

@end

@protocol LBAlphaTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign) CGFloat fromAlpha;
@property (nonatomic, assign) CGFloat toAlpha;

@end

@protocol LBMaskTransitionProtocol <LBTransitionProtocol>

@property (nonatomic, assign) BOOL isAppear;

@end

@protocol LBColorMaskTransitionProtocol <LBMaskTransitionProtocol>

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;

@end

@protocol LBContentsMaskTransitionProtocol <LBMaskTransitionProtocol>

@property (nonatomic, strong) UIImage *fromImage;
@property (nonatomic, strong) UIImage *toImage;

@end
