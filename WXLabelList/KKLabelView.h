//
//  KKLabelView.h
//  KkLenovoCamera-iOS
//
//  Created by kk on 2018/2/2.
//  Copyright © 2018年 fx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueBlock)(int code, id returnValue);


@interface KKLabelView : UIView
//所有标签的数量
@property (nonatomic, assign) NSInteger allLabelCount;

//初始化标签
- (instancetype)initWithFrame:(CGRect)frame
                    headTitle:(NSString *)headTitle
             withRootLabelAry:(NSArray *)rootLabelAry
                    rootIdAry:(NSArray *)rootIdAry
                   needAddBtn:(BOOL)needAddBtn
                     touchBtn:(ReturnValueBlock)touchBlock;

//布局最后一行的lable
//titleAry：需要布局的标签名称；idAry：需要布局的标签Id；两个数组要一一对应
//isHeadAnd：是否为手动添加；selectId：长按选择的id
- (CGFloat)layoutLastLabelAry:(NSArray *)titleAry
                  withLabelId:(NSArray *)idAry
                    isHeadAnd:(BOOL)isHeadAnd
                     selectId:(NSString *)selectId;


//全部重新布局-(修改名称的时候调用)
- (CGFloat)layoutAllLabelModifyTitle:(NSString *)modifyTitle modifyId:(NSString *)modifyId;
@end
