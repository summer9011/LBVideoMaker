//
//  LBScreenplayObj.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBScreenplayObj : NSObject

@property (nonatomic, strong) NSString *screenplayName;

@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) int32_t frames;

@property (nonatomic, assign) BOOL customBackgroundAudio;
@property (nonatomic, assign) BOOL customBackgroundVideo;

@property (nonatomic, strong) NSMutableArray *resourceList;

@end
