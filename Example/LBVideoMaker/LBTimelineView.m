//
//  LBTimelineView.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/7/3.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBTimelineView.h"

@implementation LBTimelineView

@end

@interface LBPinTimelineView ()

@property (nonatomic, strong) UIImageView *pinImageView;

@end

@implementation LBPinTimelineView

- (instancetype)init {
    if (self = [super init]) {
        UIImage *image = [UIImage imageNamed:@"Pin"];
        self.pinImageView = [[UIImageView alloc] initWithImage:image];
        self.pinImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.frame = self.pinImageView.frame;
        [self addSubview:self.pinImageView];
    }
    return self;
}

@end
