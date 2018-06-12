//
//  LBPositionProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"

@protocol LBPositionProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, assign) CGPoint fromPoint;
@property (nonatomic, assign) CGPoint toPoint;

@property (nonatomic, strong) UIBezierPath *path;

@end
