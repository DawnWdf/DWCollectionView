//
//  UIImage+DWViewShot.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/19.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UIImage+DWViewShot.h"

@implementation UIImage (DWViewShot)
+ (UIImage *)dw_imageShotFor:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 4.f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
