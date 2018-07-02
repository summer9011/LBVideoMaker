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
    
    CGFloat headTopOffset = -40;
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

+ (CALayer *)stepLayerWithImagePath:(NSString *)imagePath
                          videoSize:(CGSize)videoSize {
    CALayer *coverLayer = [CALayer layer];
    coverLayer.contentsGravity = kCAGravityResizeAspectFill;
    coverLayer.contents = (__bridge id _Nullable)([LBImageHelper blurImage:[UIImage imageWithContentsOfFile:imagePath]].CGImage);
    
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

+ (UIImage *)compareLayerImageWithBeforeImagePath:(NSString *)beforeImagePath
                                   afterImagePath:(NSString *)afterImagePath
                                        videoSize:(CGSize)videoSize {
    UIImage *beforeImage = [UIImage imageWithContentsOfFile:beforeImagePath];
    UIImage *afterImage = [UIImage imageWithContentsOfFile:afterImagePath];
    
    CGFloat margin = 20;
    
    CGFloat imageWidth = videoSize.width/2.f;
    CGSize beforeImageSize = CGSizeMake(imageWidth, imageWidth * beforeImage.size.height/beforeImage.size.width);
    CGSize afterImageSize = CGSizeMake(imageWidth, imageWidth * afterImage.size.height/afterImage.size.width);
    
    UIImage *beforeTextImage = [self imageWithImage:beforeImage text:@"Before" position:CGPointMake(0, margin) resultSize:beforeImageSize];
    UIImage *afterTextImage = [self imageWithImage:afterImage text:@"After" position:CGPointMake(0, margin) resultSize:afterImageSize];
    
    UIGraphicsBeginImageContext(videoSize);
    
    [beforeTextImage drawInRect:CGRectMake(0, 0, beforeTextImage.size.width, beforeTextImage.size.height)];
    [afterTextImage drawInRect:CGRectMake(beforeTextImage.size.width, 0, afterTextImage.size.width, afterTextImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}
+ (CALayer *)compareLayerWithContents:(UIImage *)content
                            videoSize:(CGSize)videoSize {
    CALayer *coverLayer = [CALayer layer];
    coverLayer.contentsGravity = kCAGravityResizeAspect;
    coverLayer.contents = (__bridge id _Nullable)(content.CGImage);
    
    CGRect coverRect = CGRectZero;
    coverRect.size = videoSize;
    coverLayer.frame = coverRect;
    
    return coverLayer;
}
+ (CALayer *)detailLayerWithDetail:(NSString *)detail
                         videoSize:(CGSize)videoSize {
    CGFloat margin = 20;
    
    UIFont *font;
    if (@available(iOS 9.0, *)) {
        font = [UIFont monospacedDigitSystemFontOfSize:26 weight:UIFontWeightMedium];
    } else {
        font = [UIFont systemFontOfSize:26 weight:UIFontWeightMedium];
    }
    CGSize maxTextSize = CGSizeMake(videoSize.width/2.f - margin*2, font.lineHeight * 3);
    
    UIColor *color = [UIColor colorWithRed:0x55/255.f green:0x55/255.f blue:0x55/255.f alpha:1.f];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attrs = @{
                            NSFontAttributeName:font,
                            NSForegroundColorAttributeName:color,
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
    
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(maxTextSize.width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attrs
                                             context:nil].size;
    if (detailSize.height > maxTextSize.height) {
        detailSize.height = maxTextSize.height;
    }
    
    CGRect textRect = CGRectZero;
    textRect.origin.x = margin;
    textRect.origin.y = videoSize.height - detailSize.height - margin;
    textRect.size = detailSize;
    
    CATextLayer *detailLayer = [CATextLayer layer];
    detailLayer.frame = textRect;
    detailLayer.string = detail;
    detailLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
    detailLayer.fontSize = font.pointSize;
    detailLayer.alignmentMode = kCAAlignmentLeft;
    detailLayer.foregroundColor = color.CGColor;
    detailLayer.wrapped = YES;
    detailLayer.truncationMode = kCATruncationEnd;
    
    return detailLayer;
}
+ (UIImage *)imageWithImage:(UIImage *)originImage text:(NSString *)text position:(CGPoint)position resultSize:(CGSize)resultSize {
    UIFont *font = [UIFont systemFontOfSize:28];
    UIImage *backImage = [LBImageHelper createImageWithColor:[UIColor blackColor]];
    
    CGFloat textBGWidth = 88;
    CGFloat textBGHeight = font.lineHeight + 6;
    CGRect textBGRect = CGRectMake(position.x, position.y, textBGWidth, textBGHeight);
    
    UIGraphicsBeginImageContext(resultSize);
    
    [originImage drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
    [backImage drawInRect:textBGRect];
    
    NSDictionary *attrs = @{
                            NSFontAttributeName:font,
                            NSForegroundColorAttributeName:[UIColor whiteColor]
                            };
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    CGRect textRect = CGRectZero;
    textRect.origin.x = CGRectGetMinX(textBGRect) + (textBGWidth - textSize.width)/2.f;
    textRect.origin.y = CGRectGetMinY(textBGRect) + (textBGHeight - textSize.height)/2.f;
    textRect.size = textSize;
    
    [text drawInRect:textRect withAttributes:attrs];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (CALayer *)productLayerWithProducts:(NSArray<NSDictionary *> *)products
                            videoSize:(CGSize)videoSize {
    CGFloat itemOffset = 28;
    CGFloat itemLeading = 40;
    CGFloat itemTop = 30;
    CGFloat itemHeight = 90;
    CGFloat textLeading = 20;
    
    CALayer *backgroundLayer = [self createBackgroundLayerWithItemCount:products.count perPageCount:4 parentSize:videoSize];
    
    UIFont *font = [UIFont boldSystemFontOfSize:26];
    [products enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = itemOffset + (itemHeight + itemTop) * idx;
        
        UIImage *image = [UIImage imageWithContentsOfFile:obj[@"url"]];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.masksToBounds = YES;
        imageLayer.contentsGravity = kCAGravityResizeAspectFill;
        imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
        
        CGRect imageRect = CGRectZero;
        imageRect.origin = CGPointMake(itemLeading, y);
        imageRect.size.height = itemHeight;
        imageRect.size.width = imageRect.size.height;
        imageLayer.frame = imageRect;
        
        [backgroundLayer addSublayer:imageLayer];
        
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.string = obj[@"title"];
        titleLayer.foregroundColor = [UIColor blackColor].CGColor;
        titleLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        titleLayer.fontSize = font.pointSize;
        titleLayer.alignmentMode = kCAAlignmentLeft;
        titleLayer.wrapped = YES;
        
        CGRect titleRect = CGRectZero;
        titleRect.origin = CGPointMake(CGRectGetMaxX(imageRect) + textLeading, y);
        titleRect.size.height = CGRectGetHeight(imageRect);
        titleRect.size.width = CGRectGetWidth(backgroundLayer.frame) - itemLeading * 2 - CGRectGetWidth(imageRect) - textLeading;
        titleLayer.frame = titleRect;
        
        [backgroundLayer addSublayer:titleLayer];
    }];
    
    CGRect backgroundLayerFrame = backgroundLayer.frame;
    backgroundLayerFrame.origin = CGPointZero;
    backgroundLayer.frame = backgroundLayerFrame;
    
    CALayer *backgroundContentLayer = [self backgroundLayerWithItemCount:products.count perPageCount:4 parentSize:videoSize];
    [backgroundContentLayer addSublayer:backgroundLayer];
    
    return backgroundContentLayer;
}
+ (CALayer *)backgroundLayerWithItemCount:(NSUInteger)itemCount perPageCount:(NSUInteger)perPageCount parentSize:(CGSize)parentSize {
    CALayer *backgroundLayer = [self createBackgroundLayerWithItemCount:itemCount perPageCount:perPageCount parentSize:parentSize];
    
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    shadowLayer.frame = backgroundLayer.bounds;
    shadowLayer.cornerRadius = 10;
    shadowLayer.shadowOffset = CGSizeMake(4, -20);
    shadowLayer.shadowOpacity = 0.4;
    shadowLayer.shadowRadius = 10;
    shadowLayer.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.4].CGColor;
    [backgroundLayer addSublayer:shadowLayer];
    
    return backgroundLayer;
}
+ (CALayer *)createBackgroundLayerWithItemCount:(NSUInteger)itemCount perPageCount:(NSUInteger)perPageCount parentSize:(CGSize)parentSize {
    CGFloat itemOffset = 28;
    CGFloat itemTop = 30;
    CGFloat itemHeight = 90;
    
    NSUInteger count = perPageCount;
    if (itemCount < perPageCount) {
        count = itemCount;
    }
    
    CGSize backgroundSize = CGSizeZero;
    backgroundSize.height = itemHeight * count + itemTop * (count - 1) + itemOffset * 2;
    backgroundSize.width = 530;
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.cornerRadius = 10;
    
    CGFloat backgroundTopOffset = -40;
    
    CGRect backgroundRect = CGRectZero;
    backgroundRect.size = backgroundSize;
    backgroundRect.origin.x = (parentSize.width - backgroundSize.width)/2.f;
    backgroundRect.origin.y = (parentSize.height - backgroundSize.height)/2.f + backgroundTopOffset;
    backgroundLayer.frame = backgroundRect;
    
    return backgroundLayer;
}

+ (CALayer *)watermarkLayerWithTitle:(NSString *)title
                            subTitle:(NSString *)subTitle
                              author:(NSString *)author
                                sign:(NSString *)sign
                               color:(UIColor *)color
                           videoSize:(CGSize)videoSize {
    CGFloat margin = 20;
    CGFloat maxTextWidth = videoSize.width - margin * 2;
    
    CALayer *contentLayer = [CALayer layer];
    
    //title layer
    UIFont *titleFont;
    if (@available(iOS 9.0, *)) {
        titleFont = [UIFont monospacedDigitSystemFontOfSize:26 weight:UIFontWeightBold];
    } else {
        titleFont = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    }
    
    NSDictionary *titleAttrDic = @{
                                   NSFontAttributeName:titleFont,
                                   NSForegroundColorAttributeName:color
                                   };
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [titleAttrStr addAttributes:titleAttrDic range:NSMakeRange(0, title.length)];
    
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = titleAttrStr;
    titleLayer.font = (__bridge CFTypeRef _Nullable)(titleFont.fontName);
    titleLayer.fontSize = titleFont.pointSize;
    titleLayer.alignmentMode = kCAAlignmentRight;
    titleLayer.foregroundColor = color.CGColor;
    titleLayer.shadowOpacity = 0.8;
    titleLayer.shadowRadius = 5;
    titleLayer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    [contentLayer addSublayer:titleLayer];
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:titleAttrDic
                                                  context:nil].size;
    
    //subTitle layer
    UIFont *subTitleFont;
    if (@available(iOS 9.0, *)) {
        subTitleFont = [UIFont monospacedDigitSystemFontOfSize:18 weight:UIFontWeightRegular];
    } else {
        subTitleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    UIFont *authorFont;
    if (@available(iOS 9.0, *)) {
        authorFont = [UIFont monospacedDigitSystemFontOfSize:20 weight:UIFontWeightMedium];
    } else {
        authorFont = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:subTitle];
    NSDictionary *attrs = @{
                            NSFontAttributeName:subTitleFont,
                            NSForegroundColorAttributeName:color
                            };
    [attrStr addAttributes:attrs range:NSMakeRange(0, subTitle.length)];
    
    NSRange authorRange = [subTitle rangeOfString:author];
    NSDictionary *authorAttrs = @{
                                  NSFontAttributeName:authorFont,
                                  NSForegroundColorAttributeName:color
                                  };
    [attrStr addAttributes:authorAttrs range:authorRange];
    
    CATextLayer *subTitleLayer = [CATextLayer layer];
    subTitleLayer.string = attrStr;
    subTitleLayer.font = (__bridge CFTypeRef _Nullable)(subTitleFont.fontName);
    subTitleLayer.fontSize = subTitleFont.pointSize;
    subTitleLayer.alignmentMode = kCAAlignmentRight;
    subTitleLayer.foregroundColor = color.CGColor;
    subTitleLayer.shadowOpacity = 0.8;
    subTitleLayer.shadowRadius = 5;
    subTitleLayer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    [contentLayer addSublayer:subTitleLayer];
    
    CGSize subTitleSize = [subTitle boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:authorAttrs
                                                        context:nil].size;
    
    //sign layer
    NSDictionary *signAttrDic = @{
                                  NSFontAttributeName:subTitleFont,
                                  NSForegroundColorAttributeName:color
                                  };
    NSMutableAttributedString *signAttrStr = [[NSMutableAttributedString alloc] initWithString:sign];
    [signAttrStr addAttributes:signAttrDic range:NSMakeRange(0, sign.length)];
    
    CATextLayer *signLayer = [CATextLayer layer];
    signLayer.string = signAttrStr;
    signLayer.font = (__bridge CFTypeRef _Nullable)(subTitleFont.fontName);
    signLayer.fontSize = subTitleFont.pointSize;
    signLayer.alignmentMode = kCAAlignmentRight;
    signLayer.foregroundColor = color.CGColor;
    signLayer.shadowOpacity = 1;
    signLayer.shadowRadius = 5;
    signLayer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    [contentLayer addSublayer:signLayer];
    
    CGSize signSize = [sign boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:signAttrDic
                                                     context:nil].size;
    
    CGFloat titleTopOffset = 4;
    
    CGSize headSize = CGSizeZero;
    headSize.width = maxTextWidth;
    headSize.height = titleSize.height + titleTopOffset + subTitleSize.height + signSize.height;
    
    CGRect contentRect = CGRectZero;
    contentRect.origin.x = videoSize.width - headSize.width - margin;
    contentRect.origin.y = videoSize.height - headSize.height - margin;
    contentRect.size = headSize;
    contentLayer.frame = contentRect;
    
    CGRect titleRect = CGRectZero;
    titleRect.origin.y = 0;
    titleRect.size.width = headSize.width;
    titleRect.size.height = titleSize.height;
    titleLayer.frame = titleRect;
    
    CGRect subTitleRect = CGRectZero;
    subTitleRect.origin.y = CGRectGetMaxY(titleRect) + titleTopOffset;
    subTitleRect.size.width = headSize.width;
    subTitleRect.size.height = subTitleSize.height;
    subTitleLayer.frame = subTitleRect;
    
    CGRect signRect = CGRectZero;
    signRect.origin.y = CGRectGetMaxY(subTitleRect);
    signRect.size.width = headSize.width;
    signRect.size.height = signSize.height;
    signLayer.frame = signRect;
    
    return contentLayer;
}

+ (CALayer *)imageLayerWithImagePath:(NSString *)imagePath
                           videoSize:(CGSize)videoSize {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    CALayer *coverLayer = [CALayer layer];
    coverLayer.contentsGravity = kCAGravityResizeAspect;
    coverLayer.contents = (__bridge id _Nullable)(image.CGImage);
    
    CGRect coverRect = CGRectZero;
    coverRect.size = image.size;
    coverLayer.frame = coverRect;
    [coverLayer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, -1*M_PI_4/4.f)];
    
    return coverLayer;
}

@end
