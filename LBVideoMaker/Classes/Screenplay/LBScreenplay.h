//
//  LBScreenplay.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/28.
//

#import <Foundation/Foundation.h>
#import "LBVideoProtocol.h"

@interface LBScreenplay : NSObject

+ (id<LBVideoProtocol>)createVideoObjWithScreenplay:(NSString *)screenplay;

+ (NSString *)createScreenplayWithVideoObj:(id<LBVideoProtocol>)videoObj;

@end
