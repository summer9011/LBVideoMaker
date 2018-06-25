//
//  LBLayerHelper.m
//  LBVideoMaker_Example
//
//  Created by 赵立波 on 2018/6/25.
//  Copyright © 2018年 胡萝卜_小波波. All rights reserved.
//

#import "LBLayerHelper.h"

@implementation LBLayerHelper

+ (CALayer *)headLayerWithLogoPath:(NSString *)logoPath
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                            author:(NSString *)author
                              sign:(NSString *)sign
                         videoSize:(CGSize)videoSize {
    return [self layerWithLogoPath:logoPath
                             title:title
                          subTitle:subTitle
                            author:author
                              sign:sign
                         videoSize:videoSize];
}
+ (CALayer *)footLayerWithLogoPath:(NSString *)logoPath
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                            author:(NSString *)author
                              sign:(NSString *)sign
                         videoSize:(CGSize)videoSize {
    return [self layerWithLogoPath:logoPath
                             title:title
                          subTitle:subTitle
                            author:author
                              sign:sign
                         videoSize:videoSize];
}

+ (CALayer *)layerWithLogoPath:(NSString *)logoPath
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                        author:(NSString *)author
                          sign:(NSString *)sign
                     videoSize:(CGSize)videoSize {
    CALayer *contentLayer = [CALayer layer];
    
    //logo layer
    CALayer *logoLayer = [CALayer layer];
    UIImage *logoImage = [UIImage imageWithContentsOfFile:logoPath];
    logoLayer.contents = (__bridge id _Nullable)(logoImage.CGImage);
    [contentLayer addSublayer:logoLayer];
    
    CGFloat logoImageP = logoImage.size.width/logoImage.size.height;
    CGSize imageSize = CGSizeZero;
    imageSize.width = 450;
    imageSize.height = imageSize.width/logoImageP;
    
    CGFloat minTextLeftOffset = 60;
    CGFloat textRightOffset = 40;
    CGFloat textLeft = (videoSize.width - imageSize.width)/2.f - minTextLeftOffset;
    CGFloat maxTextWidth = videoSize.width - textLeft - (videoSize.width - imageSize.width)/2.f - textRightOffset;
    
    //title layer
    UIFont *titleFont = [UIFont boldSystemFontOfSize:40];
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = title;
    titleLayer.font = (__bridge CFTypeRef _Nullable)(titleFont.fontName);
    titleLayer.fontSize = titleFont.pointSize;
    titleLayer.alignmentMode = kCAAlignmentRight;
    titleLayer.wrapped = YES;
    titleLayer.foregroundColor = [UIColor colorWithRed:231/255. green:192/255. blue:114/255. alpha:1].CGColor;
    [contentLayer addSublayer:titleLayer];
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:titleFont}
                                           context:nil].size;
    CGFloat titleTopOffset = 32;
    
    //subTitle layer
    UIFont *subTitleFont;
    if (@available(iOS 9.0, *)) {
        subTitleFont = [UIFont monospacedDigitSystemFontOfSize:28 weight:UIFontWeightRegular];
    } else {
        subTitleFont = [UIFont systemFontOfSize:28 weight:UIFontWeightRegular];
    }
    UIFont *authorFont;
    if (@available(iOS 9.0, *)) {
        authorFont = [UIFont monospacedDigitSystemFontOfSize:32 weight:UIFontWeightMedium];
    } else {
        authorFont = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:subTitle];
    NSDictionary *attrs = @{
                            NSFontAttributeName:subTitleFont,
                            NSForegroundColorAttributeName:[UIColor darkGrayColor]
                            };
    [attrStr addAttributes:attrs range:NSMakeRange(0, subTitle.length)];
    
    NSRange authorRange = [subTitle rangeOfString:author];
    NSDictionary *authorAttrs = @{
                                  NSFontAttributeName:authorFont,
                                  NSForegroundColorAttributeName:[UIColor blackColor]
                                  };
    [attrStr addAttributes:authorAttrs range:authorRange];
    
    CATextLayer *subTitleLayer = [CATextLayer layer];
    subTitleLayer.string = attrStr;
    subTitleLayer.font = (__bridge CFTypeRef _Nullable)(subTitleFont.fontName);
    subTitleLayer.fontSize = subTitleFont.pointSize;
    subTitleLayer.alignmentMode = kCAAlignmentRight;
    subTitleLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
    subTitleLayer.wrapped = YES;
    [contentLayer addSublayer:subTitleLayer];
    
    CGSize subTitleSize = [subTitle boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:authorFont}
                                                 context:nil].size;
    CGFloat subTitleTopOffset = 10;
    
    //sign layer
    CATextLayer *signLayer = [CATextLayer layer];
    signLayer.string = sign;
    signLayer.font = (__bridge CFTypeRef _Nullable)(subTitleFont.fontName);
    signLayer.fontSize = subTitleFont.pointSize;
    signLayer.alignmentMode = kCAAlignmentRight;
    signLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
    signLayer.wrapped = YES;
    [contentLayer addSublayer:signLayer];
    
    CGSize signSize = [sign boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:subTitleFont}
                                         context:nil].size;
    CGFloat signTopOffset = 4;
    
    CGFloat headTopOffset = 20;
    CGSize headSize = CGSizeZero;
    headSize.width = imageSize.width;
    if (titleSize.width + textRightOffset > headSize.width) {
        headSize.width = titleSize.width + textRightOffset;
    }
    if (subTitleSize.width + textRightOffset > headSize.width) {
        headSize.width = subTitleSize.width + textRightOffset;
    }
    if (signSize.width + textRightOffset > headSize.width) {
        headSize.width = signSize.width + textRightOffset;
    }
    headSize.height = imageSize.height + titleTopOffset + titleSize.height + subTitleTopOffset + subTitleSize.height + signTopOffset + signSize.height;
    
    CGRect contentRect = CGRectZero;
    contentRect.origin = CGPointMake((videoSize.width - headSize.width)/2.f, (videoSize.height - headSize.height)/2.f + headTopOffset);
    contentRect.size = headSize;
    contentLayer.frame = contentRect;
    
    CGRect logoRect = CGRectZero;
    logoRect.origin.x = headSize.width - imageSize.width;
    logoRect.origin.y = 0;
    logoRect.size = imageSize;
    logoLayer.frame = logoRect;
    
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = (headSize.width - textRightOffset) - titleSize.width;
    titleRect.origin.y = CGRectGetMaxY(logoRect) + titleTopOffset;
    titleRect.size = titleSize;
    titleLayer.frame = titleRect;
    
    CGRect subTitleRect = CGRectZero;
    subTitleRect.origin.x = (headSize.width - textRightOffset) - subTitleSize.width;
    subTitleRect.origin.y = CGRectGetMaxY(titleRect) + subTitleTopOffset;
    subTitleRect.size = subTitleSize;
    subTitleLayer.frame = subTitleRect;
    
    CGRect signRect = CGRectZero;
    signRect.origin.x = (headSize.width - textRightOffset) - signSize.width;
    signRect.origin.y = CGRectGetMaxY(subTitleRect) + signTopOffset;
    signRect.size = signSize;
    signLayer.frame = signRect;
    
    return contentLayer;
}

+ (CALayer *)stepLayerWithImageURL:(NSURL *)imageURL
                         videoSize:(CGSize)videoSize {
    CALayer *coverLayer = [CALayer layer];
    coverLayer.contentsGravity = kCAGravityResizeAspectFill;
    coverLayer.contents = (__bridge id _Nullable)([LBImageHelper blurImage:[UIImage imageWithContentsOfFile:imageURL.absoluteString]].CGImage);
    
    CGRect coverRect = CGRectZero;
    coverRect.size = videoSize;
    coverLayer.frame = coverRect;
    
    return coverLayer;
}
+ (CALayer *)stepContentLayerWithVideoSize:(CGSize)videoSize {
    CALayer *coverLayer = [CALayer layer];
    coverLayer.contentsGravity = kCAGravityResizeAspect;
    CGRect coverRect = CGRectZero;
    coverRect.size = videoSize;
    coverLayer.frame = coverRect;
    
    return coverLayer;
}

+ (CALayer *)compareLayerWithBeforeImageURL:(NSURL *)beforeImageURL
                              afterImageURL:(NSURL *)afterImageURL
                                  videoSize:(CGSize)videoSize {
    
}

+ (CALayer *)detailLayerWithDetail:(NSString *)detail
                         videoSize:(CGSize)videoSize {
    
}

@end
