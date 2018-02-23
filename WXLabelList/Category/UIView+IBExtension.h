//
//  UIView+IBExtension.h
//  Weibo11
//
//  Created by 刘凡 on 15/12/6.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (IBExtension)

///--- 添加边框 ---
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/// --- 添加圆角阴影 ---
//UIRectCornerTopLeft     = 1 << 0,
//UIRectCornerTopRight    = 1 << 1,
//UIRectCornerBottomLeft  = 1 << 2,
//UIRectCornerBottomRight = 1 << 3,
//UIRectCornerAllCorners
- (void)kk_addShadowWithCornerRadius:(float)radius Corners:(UIRectCorner)corners;

- (void)kk_addShadowWithCornerRadius:(float)radius;


//只设置view圆角
- (void)kk_setMaskTobyRoundingCorners:(UIRectCorner)corners
                      cornerRadius:(CGFloat)cornerRadius;

//view设置圆角，并添加边框  bColor：边框颜色
- (CAShapeLayer *)kk_setMaskTobyRoundingCorners:(UIRectCorner)corners
                                cornerRadius:(CGFloat)cornerRadius
                                  withBorder:(CGRect)rect
                                 borderColor:(UIColor *)bColor;
//
- (CAShapeLayer *)kk_setMaskTobyRoundingCorners:(UIRectCorner)corners
                                   cornerRadius:(CGFloat)cornerRadius
                                withBorderWidth:(CGFloat)borderWidth
                                 withBorderRect:(CGRect)borderRect
                                    borderColor:(UIColor *)bColor;
@end
