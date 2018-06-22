//
//  LBSceneProtocol.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "LBTimeProtocol.h"
#import "LBTransitionProtocol.h"
#import "LBPersonProtocol.h"

typedef NS_ENUM(NSUInteger, LBSceneSortType) {
    LBSceneSortDefault = 0,
    LBSceneSortFirst = 1,
    LBSceneSortLast = 2
};

@protocol LBVideoProtocol;

@protocol LBSceneProtocol <NSObject, LBTimeProtocol>

@property (nonatomic, assign) LBSceneSortType sortType;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) NSArray<id<LBPersonProtocol>> *persons;

@property (nonatomic, strong) id<LBTransitionProtocol> appear;
@property (nonatomic, strong) id<LBTransitionProtocol> disappear;

@property (nonatomic, strong) id<LBSceneProtocol> nextScene;

@property (nonatomic, weak) id<LBVideoProtocol> contentVideo;

@end
