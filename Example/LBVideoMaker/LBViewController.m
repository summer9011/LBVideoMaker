//
//  LBViewController.m
//  LBVideoMaker
//
//  Created by 胡萝卜_小波波 on 06/12/2018.
//  Copyright (c) 2018 胡萝卜_小波波. All rights reserved.
//

#import "LBViewController.h"
#import <LBVideoMaker/LBVideoMaker.h>

@interface LBViewController ()

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeVideo:(id)sender {
    [[LBVideoMaker shareMaker] makeVideo:[self createVideoObj]
                             toDirectory:NSTemporaryDirectory()
                                withName:[[NSUUID UUID].UUIDString lowercaseString]
                               extension:LBVideoExtensionDefault
                             resultBlock:^(BOOL success, NSError *error) {
                                 
                             }];
}

- (id<LBVideoProtocol>)createVideoObj {
    return nil;
}

@end
