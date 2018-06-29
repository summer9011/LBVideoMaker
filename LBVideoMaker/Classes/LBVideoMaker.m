//
//  LBVideoMaker.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import "LBVideoMaker.h"
#import <KVOController/KVOController.h>
#import <AVFoundation/AVFoundation.h>

#import "LBTransitionHelper.h"
#import "LBBehaviorHelper.h"

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
        composition.naturalSize = video.videoSize;
        
        [self insertTracksWithEnvironments:video.environments
                               composition:composition];
        
        AVMutableVideoComposition *videoComposition = nil;
        if (self.instructions.count > 0) {
            videoComposition = [AVMutableVideoComposition videoComposition];
            videoComposition.frameDuration = CMTimeMake(1, video.framePerSecond);
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
#pragma mark - Environments

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
            [LBTransitionHelper addTransition:videoEnvironment.appear
                           toLayerInstruction:layerInstruction
                                     isAppear:YES];
        }
        if (videoEnvironment.disappear) {
            [LBTransitionHelper addTransition:videoEnvironment.disappear
                           toLayerInstruction:layerInstruction
                                     isAppear:NO];
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
            CMTime startTime = CMTimeAdd(environment.absoluteStartTime, asset.duration);
            [track insertEmptyTimeRange:CMTimeRangeMake(startTime, leaveCMTime)];
        }
        [track insertTimeRange:timeRange ofTrack:assetTrack atTime:environment.absoluteStartTime error:nil];
    }
    if (environment.nextEnvironment) {
        [self insertTrackWithEnvironment:environment.nextEnvironment
                             composition:composition];
    }
}

#pragma mark - Scenes

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
    animationLayer.geometryFlipped = YES;
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
    if (scene.backgroundColor) {
        sceneLayer.backgroundColor = scene.backgroundColor.CGColor;
    }
    
    sceneLayer.opacity = (scene.sortType == LBSceneSortFirst && !scene.appear)?1:0;
    [animationLayer addSublayer:sceneLayer];
    
    if (scene.appear) {
        [LBTransitionHelper addTransition:scene.appear
                         keepDurationTime:scene.timeRange.duration
                                withLayer:sceneLayer
                            toParentLayer:animationLayer
                                 isAppear:YES];
    } else {
        if (scene.sortType != LBSceneSortFirst) {
            [LBTransitionHelper addDefaultTransitionInHost:scene
                                          keepDurationTime:scene.timeRange.duration
                                                 withLayer:sceneLayer
                                             toParentLayer:animationLayer
                                           withVideoFrames:scene.contentVideo.framePerSecond
                                                  isAppear:YES];
        }
    }
    
    CMTime keepDurationTime = CMTimeSubtract(scene.contentVideo.totalVideoTime, CMTimeRangeGetEnd(scene.timeRange));
    if (scene.disappear) {
        CMTime durationTime = scene.disappear.timeRange.duration;
        if (scene.sortType == LBSceneSortLast) {
            durationTime = CMTimeSubtract(durationTime, CMTimeMake(1, scene.timeRange.duration.timescale));
        }
        scene.disappear.timeRange = CMTimeRangeMake(scene.disappear.timeRange.start, durationTime);
        
        [LBTransitionHelper addTransition:scene.disappear
                         keepDurationTime:keepDurationTime
                                withLayer:sceneLayer
                            toParentLayer:animationLayer
                                 isAppear:NO];
    } else {
        if (scene.sortType != LBSceneSortLast) {
            [LBTransitionHelper addDefaultTransitionInHost:scene
                                          keepDurationTime:keepDurationTime
                                                 withLayer:sceneLayer
                                             toParentLayer:animationLayer
                                           withVideoFrames:scene.contentVideo.framePerSecond
                                                  isAppear:NO];
        }
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

- (void)addPersonLayerWithPerson:(id<LBPersonProtocol>)person
                    toSceneLayer:(CALayer *)sceneLayer {
    person.appearance.opacity = (person.contentScene.sortType == LBSceneSortFirst && !person.appear)?1:0;
    [sceneLayer addSublayer:person.appearance];
    
    if (person.appear) {
        [LBTransitionHelper addTransition:person.appear
                         keepDurationTime:person.timeRange.duration
                                withLayer:person.appearance
                            toParentLayer:sceneLayer
                                 isAppear:YES];
    } else {
        if (person.contentScene.sortType != LBSceneSortFirst) {
            [LBTransitionHelper addDefaultTransitionInHost:person
                                          keepDurationTime:person.timeRange.duration
                                                 withLayer:person.appearance
                                             toParentLayer:sceneLayer
                                           withVideoFrames:person.contentScene.timeRange.duration.timescale
                                                  isAppear:YES];
        }
    }
    
    CMTime keepDurationTime = CMTimeSubtract(person.contentScene.timeRange.duration, CMTimeRangeGetEnd(person.timeRange));
    if (person.disappear) {
        CMTime durationTime = person.disappear.timeRange.duration;
        if (person.contentScene.sortType == LBSceneSortLast) {
            durationTime = CMTimeSubtract(durationTime, CMTimeMake(1, person.timeRange.duration.timescale));
        }
        person.disappear.timeRange = CMTimeRangeMake(person.disappear.timeRange.start, durationTime);
        
        [LBTransitionHelper addTransition:person.disappear
                         keepDurationTime:keepDurationTime
                                withLayer:person.appearance
                            toParentLayer:sceneLayer
                                 isAppear:NO];
    } else {
        if (person.contentScene.sortType != LBSceneSortLast) {
            [LBTransitionHelper addDefaultTransitionInHost:person
                                          keepDurationTime:keepDurationTime
                                                 withLayer:person.appearance
                                             toParentLayer:sceneLayer
                                           withVideoFrames:person.contentScene.timeRange.duration.timescale
                                                  isAppear:NO];
        }
    }
    
    if (person.behaviors) {
        [person.behaviors enumerateObjectsUsingBlock:^(id<LBBehaviorProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addPersonBehaviorWithBehavior:obj
                                withPersonLayer:person.appearance
                                   toSceneLayer:sceneLayer];
        }];
    }
}

- (void)addPersonBehaviorWithBehavior:(id<LBBehaviorProtocol>)behavior
                      withPersonLayer:(CALayer *)personLayer
                         toSceneLayer:(CALayer *)sceneLayer {
    [LBBehaviorHelper addBehavior:behavior
                  withPersonLayer:personLayer
                     toSceneLayer:sceneLayer];
    
    if (behavior.nextBehavior) {
        [self addPersonBehaviorWithBehavior:behavior.nextBehavior
                            withPersonLayer:personLayer
                               toSceneLayer:sceneLayer];
    }
}

#pragma mark - Export

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
