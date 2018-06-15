//
//  LBTransitionObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBBaseObj.h"

@interface LBTransitionObj : LBBaseObj <LBTransitionProtocol>

@end

@interface LBVolumeTransitionObj : LBTransitionObj <LBVolumeTransitionProtocol>

@end

@interface LBAlphaTransitionObj : LBTransitionObj <LBAlphaTransitionProtocol>

@end

@interface LBMaskTransitionObj : LBTransitionObj <LBMaskTransitionProtocol>

@end

@interface LBColorMaskTransitionObj : LBMaskTransitionObj <LBColorMaskTransitionProtocol>

@end
