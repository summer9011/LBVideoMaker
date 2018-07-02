//
//  LBVideosController.m
//  LBVideoMaker
//
//  Created by 胡萝卜_小波波 on 06/12/2018.
//  Copyright (c) 2018 胡萝卜_小波波. All rights reserved.
//

#import "LBVideosController.h"
#import "LBDemoObj.h"

@import AVKit;
@import LBVideoMaker;

@interface LBVideosController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreBtnItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDate *> *videoDates;
@property (nonatomic, strong) NSMutableDictionary<NSDate *, NSURL *> *videoURLDic;

@property (nonatomic, strong) NSString *exportDir;

@end

@implementation LBVideosController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoDates = [NSMutableArray array];
    self.videoURLDic = [NSMutableDictionary dictionary];
    
    self.exportDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"videos"];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.exportDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.exportDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self loadVideoData];
}

#pragma mark - Actions

- (IBAction)doMoreAction:(UIBarButtonItem *)btnItem {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Tools" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *makeAction = [UIAlertAction actionWithTitle:@"Make video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self makeVideo];
    }];
    [sheet addAction:makeAction];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"Clear all videos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearAllVideos];
    }];
    [sheet addAction:clearAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:cancelAction];
    
    UIPopoverPresentationController *popover = sheet.popoverPresentationController;
    if (popover) {
        popover.barButtonItem = btnItem;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:sheet animated:YES completion:nil];
}

#pragma mark - Private Method

- (void)loadVideoData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *propertieKeys = @[NSURLContentModificationDateKey];
        NSArray<NSURL *> *fileContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:self.exportDir] includingPropertiesForKeys:propertieKeys options:0 error:nil];
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

- (void)makeVideo {
    self.moreBtnItem.enabled = NO;
    
    NSString *name = [[NSUUID UUID].UUIDString lowercaseString];
    NSString *fullPath = [[self.exportDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
    
    [[LBVideoMaker shareMaker] makeVideo:[LBDemoObj createDemoObj]
                             toDirectory:self.exportDir
                                withName:name
                               extension:LBVideoExtensionDefault
                           progressBlock:^(CGFloat progress) {
                               NSLog(@"progress %f", progress);
                           }
                             resultBlock:^(BOOL success, NSError *error) {
                                 if (success) {
                                     NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                     [self.tableView beginUpdates];
                                     [self addVideo:videoURL atIndexPath:insertIndexPath];
                                     [self.tableView endUpdates];
                                 } else {
                                     NSLog(@"error %@", error);
                                 }
                                 self.moreBtnItem.enabled = YES;
                             }];
}

- (void)clearAllVideos {
    self.moreBtnItem.enabled = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<NSURL *> *fileContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:self.exportDir] includingPropertiesForKeys:nil options:0 error:nil];
        [fileContents enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtURL:obj error:nil];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoDates removeAllObjects];
            [self.videoURLDic removeAllObjects];
            
            [self.tableView reloadData];
            self.moreBtnItem.enabled = YES;
        });
    });
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
