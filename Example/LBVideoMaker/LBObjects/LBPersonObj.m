//
//  LBPersonObj.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/15.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBPersonObj.h"

@implementation LBPersonObj

@synthesize timeRange;

@synthesize appearance;

@synthesize percentCenter;
@synthesize percentSize;
@synthesize specificSize;
@synthesize percentRect;

@synthesize moves;
@synthesize behaviors;

@synthesize appear;
@synthesize disappear;

@synthesize contentScene;

- (instancetype)initWithAppearance:(CALayer *)appearance
                       percentRect:(CGRect)percentRect
                         timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        [self resetZeroPositions];
        self.appearance = appearance;
        self.percentRect = percentRect;
        self.timeRange = timeRange;
        
        CGPoint percentCenter = CGPointZero;
        percentCenter.x = CGRectGetMinX(self.percentRect) + CGRectGetWidth(self.percentRect)/2.f;
        percentCenter.y = CGRectGetMinY(self.percentRect) + CGRectGetHeight(self.percentRect)/2.f;
        self.percentCenter = percentCenter;
        self.percentSize = self.percentRect.size;
    }
    return self;
}

- (instancetype)initWithAppearance:(CALayer *)appearance
                     percentCenter:(CGPoint)percentCenter
                       percentSize:(CGSize)percentSize
                         timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        [self resetZeroPositions];
        self.appearance = appearance;
        self.percentCenter = percentCenter;
        self.percentSize = percentSize;
        self.timeRange = timeRange;
        
        CGRect percentRect = CGRectZero;
        CGFloat x = self.percentCenter.x - self.percentSize.width/2.f;
        CGFloat y = self.percentCenter.y - self.percentSize.height/2.f;
        percentRect.origin = CGPointMake(x, y);
        percentRect.size = self.percentSize;
        self.percentRect = percentRect;
    }
    return self;
}

- (instancetype)initWithAppearance:(CALayer *)appearance
                     percentCenter:(CGPoint)percentCenter
                      specificSize:(CGSize)specificSize
                         timeRange:(CMTimeRange)timeRange {
    if (self = [super init]) {
        [self resetZeroPositions];
        self.appearance = appearance;
        self.percentCenter = percentCenter;
        self.specificSize = specificSize;
        self.timeRange = timeRange;
    }
    return self;
}

- (void)resetZeroPositions {
    self.percentCenter = CGPointZero;
    self.percentSize = CGSizeZero;
    self.specificSize = CGSizeZero;
    self.percentRect = CGRectZero;
}

@end
