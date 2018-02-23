//
//  NSString+Extension.m
//  SmartHouseKeeperIPad_iOS
//
//  Created by 陈杰 on 2017/6/12.
//  Copyright © 2017年 别智颖. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)kk_appendingStr:(NSString *)str{
    return [self stringByAppendingString:str];
}

- (NSDictionary *)kk_JsonStringToDictionary{
    if(self == nil){
        return nil;
    }
    NSError *err = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonValue = nil;
    if (data) {
        jsonValue = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                      error:&err];
    }
    
    if(err){
        NSLog(@"%@", [err description]);
    }
    return jsonValue;
}

//修剪字符串首尾的空格符 (不处理字符串中间的空格)
- (NSString *)kk_clearSpace{
    
    //也可以自定义字符集
    //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@/:;(}{}][//\\@#$%$#%$%@#!@#"];

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)kk_calculateStringSize:(CGFloat)fontSize {
    CGRect titleSize = [self boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    
    return CGSizeMake(titleSize.size.width, titleSize.size.height);
}

- (CGSize)kk_calculateStringSize:(CGFloat)fontSize withLimitSize:(CGSize)limitSize {
    CGRect titleSize = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    
    return CGSizeMake(titleSize.size.width, titleSize.size.height);
}

- (CGSize)kk_calculateBoldStringSize:(CGFloat)fontSize withLimitSize:(CGSize)limitSize {
    CGRect titleSize = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil];
    
    return CGSizeMake(titleSize.size.width, titleSize.size.height);
}

@end
