//
//  UIColor+Extension.m
//  SmartHouseKeeperIPad_iOS
//
//  Created by 陈杰 on 2017/6/6.
//  Copyright © 2017年 别智颖. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

- (UIImage *)kk_creatImageWithSize:(CGSize)size cornerRadius:(float)radius {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if(radius > 0){ //切圆角
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 1 > 开启图片上下文
        //第二个参数为不透明度 设为YES 表示不透明 性能更好
        //第三个参数为分辨率 默认为1.0,设为0表示当前设备屏幕分辨率
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        
//        // 1.1 > 不透明以后要设背景颜色,不然四个角为黑色
//        [bgColor setFill];
//        UIRectFill(rect);
        
        // 1.2 > 裁切路径 创建圆形路径,之后的绘图只会在此路径内部绘制
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, 0)];
        [path addClip];
        
        // 2 > 绘图
        [theImage drawInRect:rect];
        
        // 3 > 得到结果
        UIImage *recultImg = UIGraphicsGetImageFromCurrentImageContext();
        
        // 4 > 关闭上下文
        UIGraphicsEndImageContext();
        
        return recultImg;
        
    }
    
    return theImage;
}


@end
