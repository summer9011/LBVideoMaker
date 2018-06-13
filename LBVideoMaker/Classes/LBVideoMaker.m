//
//  LBVideoMaker.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import "LBVideoMaker.h"

@import AVFoundation;

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
        AVMutableComposition *composition = [AVMutableComposition composition];
        [self insertTracksWithEnvironment:video.environments composition:composition];
    });
}

- (void)insertTracksWithEnvironment:(NSSet<id<LBEnvironmentProtocol>> *)environments composition:(AVMutableComposition *)composition {
    __block CGSize naturalSize = CGSizeZero;
    if (environments) {
        [environments enumerateObjectsUsingBlock:^(id<LBEnvironmentProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
            AVMutableCompositionTrack *track = nil;
            AVAssetTrack *assetTrack = nil;
            if ([obj conformsToProtocol:@protocol(LBBackgroundVideoEnvironmentProtocol)]) {
                track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
                AVURLAsset *asset = [AVURLAsset assetWithURL:((id<LBBackgroundVideoEnvironmentProtocol>)obj).videoURL];
                assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
                naturalSize = assetTrack.naturalSize;
            } else if ([obj conformsToProtocol:@protocol(LBBackgroundAudioEnvironmentProtocol)]) {
                track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                AVURLAsset *asset = [AVURLAsset assetWithURL:((id<LBBackgroundAudioEnvironmentProtocol>)obj).audioURL];
                assetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
            }
            
            if (track) {
                [track insertTimeRange:obj.durition ofTrack:assetTrack atTime:obj.startTime error:nil];
            }
        }];
    }
    composition.naturalSize = naturalSize;
}

@end
