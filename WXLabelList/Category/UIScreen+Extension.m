//
//  UIScreen+Extension.m
//  Weibo11
//
//  Created by 刘凡 on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGSize)kk_screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)kk_isRetina {
    return [UIScreen kk_scale] >= 2;
}

+ (CGFloat)kk_scale {
    return [UIScreen mainScreen].scale;
}

@end
