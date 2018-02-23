//
//  KKLabelView.m
//  KkLenovoCamera-iOS
//
//  Created by kk on 2018/2/2.
//  Copyright © 2018年 fx. All rights reserved.
//

#import "KKLabelView.h"
#import "UIViewExt.h"
#import "NSString+Extension.h"
#import "UIView+IBExtension.h"
#import "UIButton+Extension.h"
#import "UIColor+Extension.h"

@interface KKLabelView()
@property (nonatomic, strong) UILabel *titleKKLabel;
@property (nonatomic, assign) CGPoint lastLabelPoint;  //最后一个label的位置+headLabel的高度
@property (nonatomic, assign) CGFloat rowSpacing;  //行间距
@property (nonatomic, assign) CGFloat itemSpacing;  //item间距
@property (nonatomic, assign) CGFloat itemHeight;   //item的行高
@property (nonatomic, strong) NSMutableArray *allTitleAry;  //所有title
@property (nonatomic, strong) NSMutableArray *allIdAry;     //所有id
@property (nonatomic, strong) NSMutableArray *lastRowItemsAry;  //最后一行的item
@property (nonatomic, assign) BOOL needAddBtn;

@property (nonatomic, copy) ReturnValueBlock selectBlock;
@end

@implementation KKLabelView

- (instancetype)initWithFrame:(CGRect)frame
                    headTitle:(NSString *)headTitle
             withRootLabelAry:(NSArray *)rootLabelAry
                    rootIdAry:(NSArray *)rootIdAry
                   needAddBtn:(BOOL)needAddBtn
                     touchBtn:(ReturnValueBlock)touchBlock {
    if (self = [super initWithFrame:frame]) {
        _selectBlock = touchBlock;
        _needAddBtn = needAddBtn;
        
        _lastLabelPoint = CGPointMake(0, 0);
        _rowSpacing = 10;
        _itemSpacing = 15;
        _itemHeight = 35;
        _lastRowItemsAry = [NSMutableArray arrayWithCapacity:3];
        
        _allTitleAry = [NSMutableArray arrayWithCapacity:3];
        _allIdAry = [NSMutableArray arrayWithCapacity:3];
        _allLabelCount = 0;
        
        //布局标题栏
        CGSize size = [headTitle kk_calculateStringSize:13
                                          withLimitSize:CGSizeMake(frame.size.width, 60)];
        CGRect rect = CGRectMake(0, 0, frame.size.width, size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor lightGrayColor];
        label.text = headTitle;
        label.numberOfLines = 0;
        [self addSubview:label];
        _titleKKLabel = label;
        _lastLabelPoint.y = label.bottom+10;
        
        CGFloat viewHeight = _lastLabelPoint.y;
        //第一次布局需要自动补上最后一个+按钮
        if (needAddBtn) {
            NSMutableArray *titleAry = [NSMutableArray arrayWithArray:rootLabelAry];
            [titleAry addObject:@"＋"];
            NSMutableArray *idAry = [NSMutableArray arrayWithArray:rootIdAry];
            [idAry addObject:@"＋"];
            viewHeight = [self layoutLastLabelAry:titleAry withLabelId:idAry isHeadAnd:NO selectId:nil];
        }else {
            viewHeight = [self layoutLastLabelAry:rootLabelAry withLabelId:rootIdAry isHeadAnd:NO selectId:nil];
        }
        //自动调整self的高度
        rect = frame;
        rect.size.height = viewHeight;
        self.frame = rect;
    }
    return self;
}

//布局最后一行的lable
//titleAry：需要布局的标签名称；idAry：需要布局的标签Id；两个数组要一一对应
- (CGFloat)layoutLastLabelAry:(NSArray *)titleAry
                  withLabelId:(NSArray *)idAry
                    isHeadAnd:(BOOL)isHeadAnd
                     selectId:(NSString *)selectId {
    if (isHeadAnd) selectId = @"";
    //先删除最后一行的label
    NSMutableArray *newLastAry = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *newIdAry = [NSMutableArray arrayWithCapacity:3];
    for (UIButton *button in _lastRowItemsAry) {
        [newLastAry addObject:button.titleLabel.text];
        [newIdAry addObject:button.specialAttribute];
        [button removeFromSuperview];
        
        [_allTitleAry removeObject:button.titleLabel.text];
        [_allIdAry removeObject:button.specialAttribute];
        _allLabelCount--;
    }
    //先清空最后一行
    [_lastRowItemsAry removeAllObjects];
    
    if (newLastAry.count == 0) { //第一次布局
        [newLastAry addObjectsFromArray:titleAry];
        [newIdAry addObjectsFromArray:idAry];
    }else if (_needAddBtn) { //新的插入到最后一个之前(最后一个一直为+)
        NSRange range = NSMakeRange(newLastAry.count-1, titleAry.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [newLastAry insertObjects:titleAry atIndexes:set];
        [newIdAry insertObjects:idAry atIndexes:set];
    }else {
        [newLastAry addObjectsFromArray:titleAry];
        [newIdAry addObjectsFromArray:idAry];
    }
    
    
    //重新布局最后一行的label
    int i=0;
    CGRect rect;
    CGFloat upItem_x=0;  //最后一个item的x
    for (NSString *str in newLastAry) {
        //计算字符串的width
        CGSize size;
        if (_needAddBtn && i==newLastAry.count-1) { //最后一个为+
            //这里限定了+的宽度，会让计算是否到下一行出现偏差
            //可以设置item的最小宽度= +的宽度，这样计算就完全一样了
            size = CGSizeMake(_itemHeight-10, _itemHeight);
        }else {
            size = [str kk_calculateStringSize:14
                                 withLimitSize:CGSizeMake(self.width-10, _itemHeight)];
            //这里可以设置size计算后的最小width
            size.width = size.width<_itemHeight-10?_itemHeight-10:size.width;
        }
        CGFloat itemWidth = size.width+10;
        //判断是否超出边界，需要换行
        if (itemWidth+upItem_x>self.width) {
            _lastLabelPoint.y += _rowSpacing+_itemHeight;
            upItem_x = 0;
            [_lastRowItemsAry removeAllObjects];
        }
        rect = CGRectMake(upItem_x, _lastLabelPoint.y, itemWidth, _itemHeight);
        upItem_x += (itemWidth+_itemSpacing);
        
        UIButton *btn = [self creatButtonWithFrame:rect
                                             title:str
                                          isAddBtn:(i==newLastAry.count-1 && _needAddBtn)
                                     addLongAction:(i!=newLastAry.count-1 && _needAddBtn)];
        //设置btn的id
        btn.specialAttribute = newIdAry[i];
        //记录最后一行的label
        [_lastRowItemsAry addObject:btn];
        //所有的都保存(重复的id剔除)
        if (![_allIdAry containsObject:btn.specialAttribute]) {
            [_allTitleAry addObject:btn.titleLabel.text];
            [_allIdAry addObject:btn.specialAttribute];
        }
        _allLabelCount++;
        
        //倒数第二个为新增的标签，默认选中；长按编辑的默认选中
        if (i==newLastAry.count-2 && isHeadAnd) [self labelAction:btn];
        else if ([btn.specialAttribute isEqualToString:selectId]) [self labelAction:btn];
        i++;
    }
    return _lastLabelPoint.y+_itemHeight;
}

//全部重新布局
- (CGFloat)layoutAllLabelModifyTitle:(NSString *)modifyTitle modifyId:(NSString *)modifyId {
    NSUInteger index = [_allIdAry indexOfObject:modifyId];
    if (index==NSNotFound) return self.height;
    
    //初始参数
    _lastLabelPoint.y = _titleKKLabel.bottom+10;
    [_lastRowItemsAry removeAllObjects];
    _allLabelCount = 0;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]])
            [obj removeFromSuperview];
    }
    [_allTitleAry replaceObjectAtIndex:index withObject:modifyTitle];
    CGFloat viewHeight = [self layoutLastLabelAry:_allTitleAry withLabelId:_allIdAry isHeadAnd:NO selectId:modifyId];
    return viewHeight;
}

//创建一个label
- (UIButton *)creatButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                          isAddBtn:(BOOL)isAddBtn
                     addLongAction:(BOOL)addLongAction {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:isAddBtn?20:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [btn setBackgroundImage:[[UIColor blueColor] kk_creatImageWithSize:btn.size cornerRadius:0]
                   forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = (1/[UIScreen mainScreen].scale);

    [btn addTarget:self action:@selector(labelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    if (addLongAction) {
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPGRAction:)];
        longPressGestureRecognizer.minimumPressDuration = 1.5;
        [btn addGestureRecognizer:longPressGestureRecognizer];
    }
    
    return btn;
}

- (void)labelAction:(UIButton *)btn {
    NSLog(@"btn.title===%@, specialAttribute===%@", btn.titleLabel.text, btn.specialAttribute);
    if ([btn.specialAttribute isEqualToString:@"＋"]) {
        _selectBlock (0, btn);
    }else {
        _selectBlock (1, btn);
    }
}

- (void)longPGRAction:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    UIButton *btn = (UIButton *)longPressGestureRecognizer.view;
    _selectBlock (2, btn);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
