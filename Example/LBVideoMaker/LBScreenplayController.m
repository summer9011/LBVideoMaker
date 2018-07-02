//
//  LBScreenplayController.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/2.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBScreenplayController.h"
#import "LBCreateScreenplayController.h"

@interface LBScreenplayController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDate *> *screenplayDates;
@property (nonatomic, strong) NSMutableDictionary<NSDate *, NSURL *> *screenplayURLDic;

@property (nonatomic, strong) NSString *exportDir;

@end

@implementation LBScreenplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenplayDates = [NSMutableArray array];
    self.screenplayURLDic = [NSMutableDictionary dictionary];
    
    self.exportDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"screenplay"];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.exportDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.exportDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self loadScreenplayData];
}

#pragma mark - Private Method

- (void)loadScreenplayData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *propertieKeys = @[NSURLContentModificationDateKey];
        NSArray<NSURL *> *fileContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:self.exportDir] includingPropertiesForKeys:propertieKeys options:0 error:nil];
        [fileContents enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary<NSURLResourceKey, id> *attributesDictionary = [obj resourceValuesForKeys:propertieKeys error:nil];
            NSDate *lastModifiedDate = [attributesDictionary objectForKey:NSURLContentModificationDateKey];
            [self.screenplayDates addObject:lastModifiedDate];
            [self.screenplayURLDic setObject:obj forKey:lastModifiedDate];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.screenplayDates sortUsingComparator:^NSComparisonResult(NSDate * _Nonnull obj1, NSDate * _Nonnull obj2) {
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

- (void)addScreenplay:(NSURL *)screenplayURL atIndexPath:(NSIndexPath *)indexPath {
    NSArray *propertieKeys = @[NSURLContentModificationDateKey];
    NSDictionary<NSURLResourceKey, id> *attributesDictionary = [screenplayURL resourceValuesForKeys:propertieKeys error:nil];
    NSDate *lastModifiedDate = [attributesDictionary objectForKey:NSURLContentModificationDateKey];
    [self.screenplayDates insertObject:lastModifiedDate atIndex:indexPath.row];
    [self.screenplayURLDic setObject:screenplayURL forKey:lastModifiedDate];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteScreenplayAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.screenplayDates[indexPath.row];
    
    NSURL *url = self.screenplayURLDic[date];
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    [self.screenplayDates removeObjectAtIndex:indexPath.row];
    [self.screenplayURLDic removeObjectForKey:date];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)openScreenplay:(NSURL *)screenplayURL {
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.screenplayDates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    NSDate *screenplayDate = self.screenplayDates[indexPath.row];
    NSURL *screenplayURL = self.screenplayURLDic[screenplayDate];
    
    cell.detailTextLabel.text = [screenplayDate description];
    cell.textLabel.text = screenplayURL.lastPathComponent;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *screenplayDate = self.screenplayDates[indexPath.row];
    NSURL *screenplayURL = self.screenplayURLDic[screenplayDate];
    [self openScreenplay:screenplayURL];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView beginUpdates];
        [self deleteScreenplayAtIndexPath:indexPath];
        [tableView endUpdates];
    }];
    return @[deleteAction];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    UINavigationController *naviVC = (UINavigationController *)segue.destinationViewController;
    LBCreateScreenplayController *createScreenplayVC = (LBCreateScreenplayController *)naviVC.viewControllers.firstObject;
    
    __weak LBScreenplayController *weakSelf = self;
    createScreenplayVC.createBlock = ^(NSURL *screenplayURL) {
        __strong LBScreenplayController *strongSelf = weakSelf;
        
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [strongSelf.tableView beginUpdates];
        [strongSelf addScreenplay:screenplayURL atIndexPath:insertIndexPath];
        [strongSelf.tableView endUpdates];
    };
    
    createScreenplayVC.hidesBottomBarWhenPushed = YES;
}

@end
