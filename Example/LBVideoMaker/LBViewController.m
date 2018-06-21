//
//  LBViewController.m
//  LBVideoMaker
//
//  Created by 胡萝卜_小波波 on 06/12/2018.
//  Copyright (c) 2018 胡萝卜_小波波. All rights reserved.
//

#import "LBViewController.h"

#import "LBVideoObj.h"

@import AVKit;
@import LBVideoMaker;

@interface LBViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *makeVideoBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDate *> *videoDates;
@property (nonatomic, strong) NSMutableDictionary<NSDate *, NSURL *> *videoURLDic;

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoDates = [NSMutableArray array];
    self.videoURLDic = [NSMutableDictionary dictionary];
    
    [self loadVideoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVideoData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *exportDir = NSTemporaryDirectory();
        NSArray *propertieKeys = @[NSURLContentModificationDateKey];
        NSArray<NSURL *> *fileContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:exportDir] includingPropertiesForKeys:propertieKeys options:0 error:nil];
        [fileContents enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary<NSURLResourceKey, id> *attributesDictionary = [obj resourceValuesForKeys:propertieKeys error:nil];
            NSDate *lastModifiedDate = [attributesDictionary objectForKey:NSURLContentModificationDateKey];
            [self.videoDates addObject:lastModifiedDate];
            [self.videoURLDic setObject:obj forKey:lastModifiedDate];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoDates sortUsingComparator:^NSComparisonResult(NSDate * _Nonnull obj1, NSDate * _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                switch (result) {
                    case NSOrderedAscending: {
                        return NSOrderedDescending;
                    }
                        break;
                    case NSOrderedDescending: {
                        return NSOrderedAscending;
                    }
                        break;
                    default: {
                        return result;
                    }
                        break;
                }
            }];
            
            [self.tableView reloadData];
        });
    });
}

- (void)addVideo:(NSURL *)videoURL atIndexPath:(NSIndexPath *)indexPath {
    NSArray *propertieKeys = @[NSURLContentModificationDateKey];
    NSDictionary<NSURLResourceKey, id> *attributesDictionary = [videoURL resourceValuesForKeys:propertieKeys error:nil];
    NSDate *lastModifiedDate = [attributesDictionary objectForKey:NSURLContentModificationDateKey];
    [self.videoDates insertObject:lastModifiedDate atIndex:indexPath.row];
    [self.videoURLDic setObject:videoURL forKey:lastModifiedDate];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteVideoAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.videoDates[indexPath.row];
    
    NSURL *url = self.videoURLDic[date];
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    [self.videoDates removeObjectAtIndex:indexPath.row];
    [self.videoURLDic removeObjectForKey:date];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)playVideo:(NSURL *)videoURL {
    AVPlayer* player = [[AVPlayer alloc] initWithURL:videoURL];
    [player play];
    AVPlayerViewController* viewController = [[AVPlayerViewController alloc]init];
    viewController.player = player;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (id<LBVideoProtocol>)createVideoObj {
    LBVideoObj *videoObj = [LBVideoObj new];
    
    CMTime videoDurationCMTime = CMTimeMakeWithSeconds(15, videoObj.frames);
    CMTime durationTime = CMTimeMakeWithSeconds(3, videoObj.frames);
    
    //enviroments
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"bg_video" ofType:@"mov"];
    LBVideoEnvironmentObj *videoEnvironmentObj = [[LBVideoEnvironmentObj alloc] initWithVideoURL:[NSURL fileURLWithPath:videoPath]
                                                                                 backgroundColor:[UIColor whiteColor]];
    videoEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, videoDurationCMTime);
    videoEnvironmentObj.appear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:0
                                                                         toAlpha:1
                                                                       timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    CMTime startTime = CMTimeSubtract(CMTimeAdd(videoEnvironmentObj.timeRange.start, videoEnvironmentObj.timeRange.duration), durationTime);
    videoEnvironmentObj.disappear = [[LBAlphaTransitionObj alloc] initWithFromAlpha:1
                                                                            toAlpha:0
                                                                          timeRange:CMTimeRangeMake(startTime, durationTime)];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"bg_audio" ofType:@"mp3"];
    LBAudioEnvironmentObj *audioEnvironmentObj = [[LBAudioEnvironmentObj alloc] initWithAudioURL:[NSURL fileURLWithPath:audioPath]];
    audioEnvironmentObj.timeRange = CMTimeRangeMake(kCMTimeZero, videoDurationCMTime);
    audioEnvironmentObj.appear = [[LBVolumeTransitionObj alloc] initWithFromVolume:0
                                                                          toVolume:1
                                                                         timeRange:CMTimeRangeMake(kCMTimeZero, durationTime)];
    startTime = CMTimeSubtract(CMTimeAdd(audioEnvironmentObj.timeRange.start, audioEnvironmentObj.timeRange.duration), durationTime);
    audioEnvironmentObj.disappear = [[LBVolumeTransitionObj alloc] initWithFromVolume:1
                                                                             toVolume:0
                                                                            timeRange:CMTimeRangeMake(startTime, durationTime)];
    
    videoObj.environments = [NSSet setWithObjects:videoEnvironmentObj,audioEnvironmentObj, nil];
    
    return videoObj;
}

- (IBAction)makeVideo:(id)sender {
    self.makeVideoBtn.enabled = NO;
    
    NSString *dir = NSTemporaryDirectory();
    NSString *name = [[NSUUID UUID].UUIDString lowercaseString];
    NSString *fullPath = [[dir stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
    
    [[LBVideoMaker shareMaker] makeVideo:[self createVideoObj]
                             toDirectory:dir
                                withName:name
                               extension:LBVideoExtensionDefault
                           progressBlock:^(CGFloat progress) {
                               NSLog(@"progress %f", progress);
                           }
                             resultBlock:^(BOOL success, NSError *error) {
                                 self.makeVideoBtn.enabled = YES;
                                 
                                 if (success) {
                                     NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                     [self.tableView beginUpdates];
                                     [self addVideo:videoURL atIndexPath:insertIndexPath];
                                     [self.tableView endUpdates];
                                 } else {
                                     NSLog(@"error %@", error);
                                 }
                             }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoDates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    NSDate *videoDate = self.videoDates[indexPath.row];
    NSURL *videoURL = self.videoURLDic[videoDate];
    
    cell.detailTextLabel.text = [videoDate description];
    cell.textLabel.text = videoURL.lastPathComponent;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *videoDate = self.videoDates[indexPath.row];
    NSURL *videoURL = self.videoURLDic[videoDate];
    [self playVideo:videoURL];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView beginUpdates];
        [self deleteVideoAtIndexPath:indexPath];
        [tableView endUpdates];
    }];
    return @[deleteAction];
}

@end
