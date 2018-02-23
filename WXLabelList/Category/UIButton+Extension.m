//
//  UIButton+Extension.m
//  Weibo11
//
//  Created by 刘凡 on 15/12/5.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

//新增属性
static const char btnSpecialAttributeKey;

@implementation UIButton (Extension)

#pragma mark ----- 新增一个属性 -----
#pragma mark - set — specialAttribute
- (void)setSpecialAttribute:(NSString *)specialAttribute {
    objc_setAssociatedObject(self, &btnSpecialAttributeKey, specialAttribute, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - get - specialAttribute
- (NSString *)specialAttribute {
    NSString *bSpecialAttribute = objc_getAssociatedObject(self, &btnSpecialAttributeKey);
    return bSpecialAttribute;
}
@end
