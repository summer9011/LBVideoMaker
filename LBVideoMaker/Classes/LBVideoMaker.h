//
//  LBVideoMaker.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBVideoProtocol.h"

typedef void(^LBVideoMakerProgressBlock)(CGFloat progress);
typedef void(^LBVideoMakerBlock)(BOOL success, NSError *error);

typedef NS_ENUM(NSUInteger, LBVideoExtensionType) {
    LBVideoExtensionMP4 = 1,
    LBVideoExtensionDefault = LBVideoExtensionMP4
};

@interface LBVideoMaker : NSObject

+ (LBVideoMaker *)shareMaker;

- (NSString *)makeVideo:(id<LBVideoProtocol>)video
            toDirectory:(NSString *)directory
               withName:(NSString *)name
              extension:(LBVideoExtensionType)extension
          progressBlock:(LBVideoMakerProgressBlock)progressBlock
            resultBlock:(LBVideoMakerBlock)resultBlock;

- (void)cancelMakeVideo:(NSString *)makingIdentifier;

@end
