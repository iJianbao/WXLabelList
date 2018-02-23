//
//  NSString+Extension.h
//  SmartHouseKeeperIPad_iOS
//
//  Created by 陈杰 on 2017/6/12.
//  Copyright © 2017年 别智颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (NSString *)kk_appendingStr:(NSString *)str;

- (NSDictionary *)kk_JsonStringToDictionary;

- (NSString *)kk_clearSpace; //修剪字符串首尾的空格符 (不处理字符串中间的空格)

- (CGSize)kk_calculateStringSize:(CGFloat)fontSize;

- (CGSize)kk_calculateStringSize:(CGFloat)fontSize withLimitSize:(CGSize)limitSize;

- (CGSize)kk_calculateBoldStringSize:(CGFloat)fontSize withLimitSize:(CGSize)limitSize;
@end
