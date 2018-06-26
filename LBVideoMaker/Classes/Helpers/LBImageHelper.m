//
//  LBImageHelper.m
//  LBVideoMaker
//
//  Created by 赵立波 on 2018/6/22.
//

#import "LBImageHelper.h"

@implementation LBImageHelper

+ (UIImage *)blurImage:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(30), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)imageWithLayer:(CALayer *)layer {
    UIGraphicsBeginImageContext(layer.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
