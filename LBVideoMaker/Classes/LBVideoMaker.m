//
//  LBVideoMaker.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import "LBVideoMaker.h"
#import <AVFoundation/AVFoundation.h>

@interface LBVideoMaker ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LBVideoMaker

+ (LBVideoMaker *)shareMaker {
    static LBVideoMaker *maker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maker = [[self alloc] init];
        maker.queue = dispatch_queue_create("com.lbvideomaker.maker", NULL);
    });
    return maker;
}

- (void)makeVideo:(id<LBVideoProtocol>)video toDirectory:(NSString *)directory withName:(NSString *)name extension:(LBVideoExtensionType)extension resultBlock:(LBVideoMakerBlock)resultBlock {
    dispatch_sync(self.queue, ^{
        
    });
}

@end
