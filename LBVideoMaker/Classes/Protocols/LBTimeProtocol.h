//
//  LBTimeProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LBTimeProtocol <NSObject>

@property (nonatomic, assign) CMTimeRange timeRange;
@property (nonatomic, assign, readonly) CMTime absoluteStartTime;

@end
