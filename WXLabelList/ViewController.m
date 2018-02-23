//
//  ViewController.m
//  WXLabelList
//
//  Created by kk on 2018/2/23.
//  Copyright © 2018年 fx. All rights reserved.
//

#import "ViewController.h"
#import "KKLabelView.h"
#import "UIViewExt.h"
#import "UIButton+Extension.h"

@interface ViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *roomScrollView;
@property (nonatomic, strong) KKLabelView *customLabelView;
@property (nonatomic, strong) KKLabelView *recommendLabelView;

@property (nonatomic, strong) UIButton *selectLabelBtn;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) NSMutableArray *labelsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin_top = 120;
    [self initViewTwo:margin_top+20];
    
}

- (void)initViewTwo:(CGFloat)margin_top {
    CGRect rect = CGRectMake(30, margin_top, self.view.width-30*2,
                             self.view.height-margin_top);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:scrollView];
    
    rect = CGRectMake(0, 0, scrollView.width, 150);
    typeof(self) __weak sw = self;
    KKLabelView *labelView = [[KKLabelView alloc] initWithFrame:rect
                                                      headTitle:@"Select lacation"
                                               withRootLabelAry:@[@"My room"]
                                                      rootIdAry:@[@"My room1"]
                                                     needAddBtn:YES
                                                       touchBtn:^(int code, id returnValue) {
                                                           if (code==0) {
                                                               [sw showAlertCreatLabel:nil];
                                                           }else if (code==1) {
                                                               sw.selectLabelBtn = returnValue;
                                                           }else {
                                                               [sw showAlertCreatLabel:returnValue];
                                                           }
                                                       }];
    [scrollView addSubview:labelView];
    _customLabelView = labelView;
    
    rect = CGRectMake(0, _customLabelView.bottom+20, _customLabelView.width, 150);
    labelView = [[KKLabelView alloc] initWithFrame:rect
                                         headTitle:@"Recommended"
                                  withRootLabelAry:@[@"Living room", @"Bedroom", @"Kitchen"]
                                         rootIdAry:@[@"Living room1", @"Bedroom1", @"Kitchen1"]
                                        needAddBtn:NO
                                          touchBtn:^(int code, id returnValue) {
                                              sw.selectLabelBtn = returnValue;
                                          }];
    [scrollView addSubview:labelView];
    _recommendLabelView = labelView;
    
    scrollView.contentSize = CGSizeMake(scrollView.width, _recommendLabelView.bottom+10);
    _roomScrollView = scrollView;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 弹出创建标签的名称
- (void)showAlertCreatLabel:(UIButton *)btn {
    NSString *fileTitle = btn?btn.titleLabel.text:@"";
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Room name"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = fileTitle;
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UITextFieldTextDidChangeNotification object:nil];
                                                             
                                                         }];
    [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    //确定
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"CONFIRM"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UITextFieldTextDidChangeNotification object:nil];
                                                         
                                                         NSString *tfText= alertController.textFields.firstObject.text;
                                                         [weakSelf editNewTagWithBtn:btn name:tfText];
                                                         
                                                     }];
    if (fileTitle.length == 0) {
        okAction.enabled = NO;
    }
    [okAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//编辑/新建tag
- (void)editNewTagWithBtn:(UIButton *)btn name:(NSString *)name{
    
    //限制名称
    NSString *str = name;
    if (str.length == 0) {
        return;
    }
    
    CGFloat customHeight = 0;
    if (btn) { //修改名称
        customHeight = [_customLabelView layoutAllLabelModifyTitle:str modifyId:btn.specialAttribute];
    }else {
        NSString *countstr = [NSString stringWithFormat:@"%d", (int)_customLabelView.allLabelCount+1];
        NSLog(@"新增标签id====%@", countstr);
        customHeight = [_customLabelView layoutLastLabelAry:@[str] withLabelId:@[countstr] isHeadAnd:YES selectId:nil];
    }
    CGRect rect = _customLabelView.frame;
    CGFloat transform_y = customHeight-rect.size.height;
    rect.size.height = customHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        _customLabelView.frame = rect;
        _recommendLabelView.transform = CGAffineTransformTranslate(_recommendLabelView.transform, 0, transform_y);
    } completion:^(BOOL finished) {
        _roomScrollView.contentSize = CGSizeMake(_roomScrollView.width, _recommendLabelView.bottom+10);
    }];
    
}

#pragma mark - ----- 通知方法 -----
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *tf = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = tf.text.length > 0;
        
        //长度限制
        [self limitLength:tf];
    }
}

- (void)limitLength:(UITextField *)tf{
    //长度限制
    NSString * temp = tf.text;
    if (tf.markedTextRange ==nil) {
        while(1) {
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 60) {
                break;
            } else {
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        tf.text=temp;
    }
}

#pragma mark - set 方法
- (void)setSelectLabelBtn:(UIButton *)selectLabelBtn {
    if (_selectLabelBtn != selectLabelBtn) {
        _selectLabelBtn.selected = NO;
        _selectLabelBtn.layer.borderColor = [UIColor blackColor].CGColor;
        selectLabelBtn.selected = YES;
    }else {
        _selectLabelBtn.selected = !_selectLabelBtn.selected;
    }
    _selectLabelBtn = selectLabelBtn;
    if (_selectLabelBtn.selected) {
        _selectLabelBtn.layer.borderColor = [UIColor blueColor].CGColor;
    }else {
        _selectLabelBtn.layer.borderColor = [UIColor blueColor].CGColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
