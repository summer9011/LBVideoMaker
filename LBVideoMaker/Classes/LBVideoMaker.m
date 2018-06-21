//
//  LBVideoMaker.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import "LBVideoMaker.h"

#import "LBTransitionHelper.h"

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
            int32_t timescale = (video.frames > 0)?video.frames:30;
            videoComposition.frameDuration = CMTimeMake(1, timescale);
            videoComposition.renderSize = composition.naturalSize;
            videoComposition.instructions = self.instructions;

            [self addAnimationToolWithScenes:video.scenes videoComposition:videoComposition];
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
    AVURLAsset *asset = nil;
    if ([environment conformsToProtocol:@protocol(LBVideoEnvironmentProtocol)]) {
        id<LBVideoEnvironmentProtocol> videoEnvironment = (id<LBVideoEnvironmentProtocol>)environment;
        
        NSArray<AVMutableCompositionTrack *> *tracks = [composition tracksWithMediaType:AVMediaTypeVideo];
        if (tracks.count > 0) {
            track = tracks.firstObject;
        } else {
            track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        }
        
        asset = [AVURLAsset assetWithURL:videoEnvironment.videoURL];
        assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
        if (videoEnvironment.appear) {
            [LBTransitionHelper addTransition:videoEnvironment.appear toLayerInstruction:layerInstruction];
        }
        if (videoEnvironment.disappear) {
            [LBTransitionHelper addTransition:videoEnvironment.disappear toLayerInstruction:layerInstruction];
        }
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.backgroundColor = videoEnvironment.backgroundColor.CGColor;
        instruction.timeRange = videoEnvironment.timeRange;
        instruction.layerInstructions = @[layerInstruction];
        
        [self.instructions addObject:instruction];
        
    } else if ([environment conformsToProtocol:@protocol(LBAudioEnvironmentProtocol)]) {
        id<LBAudioEnvironmentProtocol> audioEnvironment = (id<LBAudioEnvironmentProtocol>)environment;
        
        NSArray<AVMutableCompositionTrack *> *tracks = [composition tracksWithMediaType:AVMediaTypeAudio];
        if (tracks.count > 0) {
            track = tracks.firstObject;
        } else {
            track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        }
        
        BOOL existAudioTransition = NO;
        asset = [AVURLAsset assetWithURL:audioEnvironment.audioURL];
        assetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        if (audioEnvironment.appear) {
            existAudioTransition = YES;
            [LBTransitionHelper addTransition:audioEnvironment.appear toAudioMixInputParameters:audioMixInputParameters];
        }
        if (audioEnvironment.disappear) {
            existAudioTransition = YES;
            [LBTransitionHelper addTransition:audioEnvironment.disappear toAudioMixInputParameters:audioMixInputParameters];
        }
        if (existAudioTransition) {
            [self.audioMixInputParameters addObject:audioMixInputParameters];
        }
    }
    if (track) {
        CMTimeRange timeRange;
        CMTime leaveCMTime = CMTimeSubtract(asset.duration, environment.timeRange.duration);
        if (CMTimeGetSeconds(leaveCMTime) > 0) {
            timeRange = CMTimeRangeMake(kCMTimeZero, environment.timeRange.duration);
        } else {
            timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
            CMTime startTime = CMTimeAdd(environment.timeRange.start, asset.duration);
            [track insertEmptyTimeRange:CMTimeRangeMake(startTime, leaveCMTime)];
        }
        [track insertTimeRange:timeRange ofTrack:assetTrack atTime:environment.timeRange.start error:nil];
    }
    if (environment.nextEnvironment) {
        [self insertTrackWithEnvironment:environment.nextEnvironment
                             composition:composition];
    }
}

- (void)addAnimationToolWithScenes:(NSArray<id<LBSceneProtocol>> *)scenes videoComposition:(AVMutableVideoComposition *)videoComposition {
    CGRect layerRect = CGRectZero;
    layerRect.size = videoComposition.renderSize;
    
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = layerRect;
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = layerRect;
    [parentLayer addSublayer:videoLayer];
    
    CALayer *animationLayer = [CALayer layer];
    animationLayer.frame = layerRect;
    [parentLayer addSublayer:animationLayer];
    
    [self addSceneLayersWithScenes:scenes
                  toAnimationLayer:animationLayer];
    
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (void)addSceneLayersWithScenes:(NSArray<id<LBSceneProtocol>> *)scenes
                toAnimationLayer:(CALayer *)animationLayer {
    if (scenes) {
        [scenes enumerateObjectsUsingBlock:^(id<LBSceneProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSceneLayerWithScene:obj
                        toAnimationLayer:animationLayer];
        }];
    }
}

- (void)addSceneLayerWithScene:(id<LBSceneProtocol>)scene
              toAnimationLayer:(CALayer *)animationLayer {
    CALayer *sceneLayer = [CALayer layer];
    sceneLayer.frame = animationLayer.bounds;
    sceneLayer.opacity = 0.f;
    [animationLayer addSublayer:sceneLayer];
    
    if (scene.appear) {
        [LBTransitionHelper addTransition:scene.appear withLayer:sceneLayer toParentLayer:animationLayer];
    } else {
        [LBTransitionHelper addDefaultAppearTransitionWithLayer:sceneLayer toParentLayer:animationLayer];
    }
    if (scene.disappear) {
        [LBTransitionHelper addTransition:scene.disappear withLayer:sceneLayer toParentLayer:animationLayer];
    } else {
        [LBTransitionHelper addDefaultDisappearTransitionWithLayer:sceneLayer toParentLayer:animationLayer];
    }
    
    if (scene.persons) {
        [scene.persons enumerateObjectsUsingBlock:^(id<LBPersonProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addPersonLayerWithPerson:obj toSceneLayer:sceneLayer];
        }];
    }
    
    if (scene.nextScene) {
        [self addSceneLayerWithScene:scene.nextScene
                    toAnimationLayer:animationLayer];
    }
}

- (void)addPersonLayerWithPerson:(id<LBPersonProtocol>)person toSceneLayer:(CALayer *)sceneLayer {
    if (person.appear) {
        
    }
    if (person.disappear) {
        
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
    session.outputURL = fileURL;
    session.outputFileType = [self fileTypeForExtensionType:extension];
    if (videoComposition) {
        session.videoComposition = videoComposition;
    }
    if (audioMix) {
        session.audioMix = audioMix;
    }
    
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
