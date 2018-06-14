//
//  LBVideoMaker.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import "LBVideoMaker.h"

@import AVFoundation;
@import KVOController;

@interface LBVideoMaker ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) FBKVOController *kvoController;

@property (nonatomic, strong) NSMutableArray<AVMutableVideoCompositionInstruction *> *instructions;
@property (nonatomic, strong) NSMutableArray<AVMutableAudioMixInputParameters *> *audioMixInputParameters;

@property (nonatomic, strong) NSMutableDictionary<NSString *, AVAssetExportSession *> *exportSessionDic;

@end

@implementation LBVideoMaker

+ (LBVideoMaker *)shareMaker {
    static LBVideoMaker *maker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maker = [[self alloc] init];
        maker.queue = dispatch_queue_create("com.lbvideomaker.maker", NULL);
        maker.KVOController = [FBKVOController controllerWithObserver:maker];
    });
    return maker;
}

- (NSString *)makeVideo:(id<LBVideoProtocol>)video
            toDirectory:(NSString *)directory
               withName:(NSString *)name
              extension:(LBVideoExtensionType)extension
          progressBlock:(LBVideoMakerProgressBlock)progressBlock
            resultBlock:(LBVideoMakerBlock)resultBlock {
    NSString *makingIdentifier = [[NSUUID UUID].UUIDString localizedLowercaseString];
    
    dispatch_async(self.queue, ^{
        [self.instructions removeAllObjects];
        [self.audioMixInputParameters removeAllObjects];
        
        AVMutableComposition *composition = [AVMutableComposition composition];
        
        [self insertTracksWithEnvironments:video.environments
                               composition:composition];
        
        AVMutableVideoComposition *videoComposition = nil;
        if (self.instructions.count > 0) {
            videoComposition = [AVMutableVideoComposition videoComposition];
            videoComposition.renderSize = composition.naturalSize;
            videoComposition.instructions = self.instructions;
            int32_t timescale = (video.frames > 0)?video.frames:30;
            videoComposition.frameDuration = CMTimeMake(1, timescale);
        }
        
        AVMutableAudioMix *audioMix = nil;
        if (self.audioMixInputParameters.count > 0) {
            audioMix = [AVMutableAudioMix audioMix];
            audioMix.inputParameters = self.audioMixInputParameters;
        }
        
        NSString *fullPath = [[directory stringByAppendingPathComponent:name] stringByAppendingPathExtension:[self extensionForExtensionType:extension]];
        [self exportVideoWithIdentifier:makingIdentifier
                            composition:composition
                       videoComposition:videoComposition
                               audioMix:audioMix
                              toFileURL:[NSURL fileURLWithPath:fullPath]
                              extension:extension
                          progressBlock:progressBlock
                            resultBlock:resultBlock];
    });
    
    return makingIdentifier;
}

- (void)cancelMakeVideo:(NSString *)makingIdentifier {
    dispatch_async(self.queue, ^{
        AVAssetExportSession *exportSession = self.exportSessionDic[makingIdentifier];
        if (exportSession) {
            [exportSession cancelExport];
            [self.exportSessionDic removeObjectForKey:makingIdentifier];
        }
    });
}

#pragma mark - Private Method

- (void)insertTracksWithEnvironments:(NSSet<id<LBEnvironmentProtocol>> *)environments
                         composition:(AVMutableComposition *)composition {
    if (environments) {
        [environments enumerateObjectsUsingBlock:^(id<LBEnvironmentProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
            [self insertTrackWithEnvironment:obj
                                 composition:composition];
        }];
    }
}

- (void)insertTrackWithEnvironment:(id<LBEnvironmentProtocol>)environment
                       composition:(AVMutableComposition *)composition {
    AVMutableCompositionTrack *track = nil;
    AVAssetTrack *assetTrack = nil;
    if ([environment conformsToProtocol:@protocol(LBBackgroundVideoEnvironmentProtocol)]) {
        id<LBBackgroundVideoEnvironmentProtocol> videoEnvironment = (id<LBBackgroundVideoEnvironmentProtocol>)environment;
        
        track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVURLAsset *asset = [AVURLAsset assetWithURL:videoEnvironment.videoURL];
        assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:assetTrack];
        if (videoEnvironment.startTransition) {
            if ([videoEnvironment.startTransition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
                id<LBAlphaTransitionProtocol> alphaTransition = (id<LBAlphaTransitionProtocol>)videoEnvironment.startTransition;
                [layerInstruction setOpacityRampFromStartOpacity:alphaTransition.fromAlpha toEndOpacity:alphaTransition.toAlpha timeRange:alphaTransition.timeRange];
            }
        }
        if (videoEnvironment.endTransition) {
            if ([videoEnvironment.endTransition conformsToProtocol:@protocol(LBAlphaTransitionProtocol)]) {
                id<LBAlphaTransitionProtocol> alphaTransition = (id<LBAlphaTransitionProtocol>)videoEnvironment.startTransition;
                [layerInstruction setOpacityRampFromStartOpacity:alphaTransition.fromAlpha toEndOpacity:alphaTransition.toAlpha timeRange:alphaTransition.timeRange];
            }
        }
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.backgroundColor = videoEnvironment.backgroundColor.CGColor;
        instruction.timeRange = videoEnvironment.timeRange;
        instruction.layerInstructions = @[layerInstruction];
        
        [self.instructions addObject:instruction];
        
    } else if ([environment conformsToProtocol:@protocol(LBBackgroundAudioEnvironmentProtocol)]) {
        id<LBBackgroundAudioEnvironmentProtocol> audioEnvironment = (id<LBBackgroundAudioEnvironmentProtocol>)environment;
        
        track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVURLAsset *asset = [AVURLAsset assetWithURL:audioEnvironment.audioURL];
        assetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        
        BOOL existAudioTransition = NO;
        AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:assetTrack];
        if (audioEnvironment.startTransition) {
            if ([audioEnvironment.startTransition conformsToProtocol:@protocol(LBVolumeTransitionProtocol)]) {
                existAudioTransition = YES;
                id<LBVolumeTransitionProtocol> volumeTransition = (id<LBVolumeTransitionProtocol>)audioEnvironment.startTransition;
                [audioMixInputParameters setVolumeRampFromStartVolume:volumeTransition.fromVolume toEndVolume:volumeTransition.toVolume timeRange:volumeTransition.timeRange];
            }
        }
        if (audioEnvironment.endTransition) {
            if ([audioEnvironment.endTransition conformsToProtocol:@protocol(LBVolumeTransitionProtocol)]) {
                existAudioTransition = YES;
                id<LBVolumeTransitionProtocol> volumeTransition = (id<LBVolumeTransitionProtocol>)audioEnvironment.startTransition;
                [audioMixInputParameters setVolumeRampFromStartVolume:volumeTransition.fromVolume toEndVolume:volumeTransition.toVolume timeRange:volumeTransition.timeRange];
            }
        }
        if (existAudioTransition) {
            [self.audioMixInputParameters addObject:audioMixInputParameters];
        }
    }
    if (track) {
        [track insertTimeRange:environment.availableTimeRange ofTrack:assetTrack atTime:environment.timeRange.start error:nil];
    }
    if (environment.nextEnvironment) {
        [self insertTrackWithEnvironment:environment.nextEnvironment
                             composition:composition];
    }
}

- (void)exportVideoWithIdentifier:(NSString *)identifier
                      composition:(AVMutableComposition *)composition
                 videoComposition:(AVMutableVideoComposition *)videoComposition
                         audioMix:(AVMutableAudioMix *)audioMix
                        toFileURL:(NSURL *)fileURL
                        extension:(LBVideoExtensionType)extension
                    progressBlock:(LBVideoMakerProgressBlock)progressBlock
                      resultBlock:(LBVideoMakerBlock)resultBlock {
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    [self.exportSessionDic setObject:session forKey:identifier];
    [self.kvoController observe:session
                        keyPath:@"progress"
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (progressBlock) {
                                      progressBlock([change[NSKeyValueChangeNewKey] floatValue]);
                                  }
                              });
                          }];
    
    session.outputURL = fileURL;
    session.outputFileType = [self fileTypeForExtensionType:extension];
    if (videoComposition) {
        session.videoComposition = videoComposition;
    }
    if (audioMix) {
        session.audioMix = audioMix;
    }
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(self.queue, ^{
            BOOL success;
            NSError *error;
            switch (session.status) {
                case AVAssetExportSessionStatusCompleted:
                    success = YES;
                    error = nil;
                    break;
                default:
                    success = NO;
                    error = session.error;
                    break;
            }
            
            [self.instructions removeAllObjects];
            [self.audioMixInputParameters removeAllObjects];
            [self.exportSessionDic removeObjectForKey:identifier];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultBlock) {
                    resultBlock(success, error);
                }
            });
        });
    }];
}

- (NSString *)extensionForExtensionType:(LBVideoExtensionType)type {
    switch (type) {
        case LBVideoExtensionMP4: {
            return @"mp4";
        }
            break;
    }
    return @"mp4";
}

- (AVFileType)fileTypeForExtensionType:(LBVideoExtensionType)type {
    switch (type) {
        case LBVideoExtensionMP4: {
            return AVFileTypeMPEG4;
        }
            break;
    }
    return AVFileTypeMPEG4;
}

#pragma mark - Getting

- (NSMutableArray<AVMutableVideoCompositionInstruction *> *)instructions {
    if (_instructions == nil) {
        _instructions = [NSMutableArray array];
    }
    return _instructions;
}

- (NSMutableArray<AVMutableAudioMixInputParameters *> *)audioMixInputParameters {
    if (_audioMixInputParameters == nil) {
        _audioMixInputParameters = [NSMutableArray array];
    }
    return _audioMixInputParameters;
}

- (NSMutableDictionary<NSString *, AVAssetExportSession *> *)exportSessionDic {
    if (_exportSessionDic == nil) {
        _exportSessionDic = [NSMutableDictionary dictionary];
    }
    return _exportSessionDic;
}

@end
