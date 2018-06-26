//
//  LBLayerHelper.h
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/25.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import <Foundation/Foundation.h>

@import LBVideoMaker;

@interface LBLayerHelper : NSObject

+ (CALayer *)headLayerWithLogoPath:(NSString *)logoPath
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                            author:(NSString *)author
                              sign:(NSString *)sign
                         videoSize:(CGSize)videoSize;
+ (CALayer *)footLayerWithLogoPath:(NSString *)logoPath
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                            author:(NSString *)author
                              sign:(NSString *)sign
                         videoSize:(CGSize)videoSize;

+ (CALayer *)stepLayerWithImageURL:(NSURL *)imageURL
                         videoSize:(CGSize)videoSize;
+ (CALayer *)stepContentLayerWithVideoSize:(CGSize)videoSize;

+ (UIImage *)compareLayerImageWithBeforeImageURL:(NSURL *)beforeImageURL
                                   afterImageURL:(NSURL *)afterImageURL
                                       videoSize:(CGSize)videoSize;
+ (CALayer *)compareLayerWithContents:(UIImage *)content
                            videoSize:(CGSize)videoSize;
+ (CALayer *)detailLayerWithDetail:(NSString *)detail
                         videoSize:(CGSize)videoSize;

+ (CALayer *)productLayerWithProducts:(NSArray<NSDictionary *> *)products
                            videoSize:(CGSize)videoSize;

+ (CALayer *)watermarkLayerWithTitle:(NSString *)title
                            subTitle:(NSString *)subTitle
                              author:(NSString *)author
                                sign:(NSString *)sign
                               color:(UIColor *)color
                           videoSize:(CGSize)videoSize;

@end
