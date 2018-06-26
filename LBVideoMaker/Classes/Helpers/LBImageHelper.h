//
//  LBImageHelper.h
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/22.
//

#import <Foundation/Foundation.h>

@interface LBImageHelper : NSObject

+ (UIImage *)blurImage:(UIImage *)image;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)imageWithLayer:(CALayer *)layer;

@end
