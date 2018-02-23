//
//  UIButton+Extension.h
//  Weibo11
//
//  Created by 刘凡 on 15/12/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ButtonImgViewStyleTop,  //图片在上
    ButtonImgViewStyleLeft, //图片在左
    ButtonImgViewStyleBottom, //图片在下
    ButtonImgViewStyleRight, //图片在右
} ButtonImgViewStyle;


@interface UIButton (Extension)

@property (nonatomic, copy) NSString *specialAttribute;

@end
