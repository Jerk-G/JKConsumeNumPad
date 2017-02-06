//
//  ZHTConsumeNumPad.m
//  ZheHuiTong
//
//  Created by apple on 16/12/7.
//  Copyright © 2016年 faNaiSheng. All rights reserved.
//

#import "JKConsumePad.h"
#import "UIView+ExtensionFrame.h"
#import "UIImage+ResizedImage.h"
#import "JKConsumeButton.h"

// 定义颜色
#define RGB(r,g,b) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b /255.0 alpha:1.0])
#define RGBA(r,g,b,a) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b /255.0 alpha:a/1.0])

// 定义机型
#define  iPhone4     ([[UIScreen mainScreen] bounds].size.height==480)
#define  iPhone5     ([[UIScreen mainScreen] bounds].size.height==568)
#define  iPhone6     ([[UIScreen mainScreen] bounds].size.height==667)
#define  iPhone6plus ([[UIScreen mainScreen] bounds].size.height==736)

#define margin 0.8 // 按钮间距
#define column 4 // 列数

#define maxFund 10000000000 // 限额

@interface JKConsumePad()
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) NSArray *receiveMoenyArr;
@property (nonatomic, assign) CGFloat buttonY;
@property (nonatomic, strong) UILabel *label;// 显示输入金额的label
@property (nonatomic, strong) NSMutableString *string;
@property (nonatomic, strong) UIButton *receiveMoneyButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) JKConsumeButton *receiveBtn1;
@property (nonatomic, strong) JKConsumeButton *receiveBtn2;
//@property (nonatomic, strong) UIView *showNumView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) double num1;
@property (nonatomic, assign) double num2;

@property (nonatomic, assign) double resultNum;
@property (nonatomic, assign) double resultAddNum;

@property (nonatomic, assign) BOOL plusIsClicked;
@end

@implementation JKConsumePad

- (NSArray *)titleArr {
    if (!_titleArr) {
        self.titleArr = [NSArray arrayWithObjects:@"1", @"2", @"3", @"删除", @"4", @"5", @"6", @"清空", @"7", @"8", @"9", @"", @"0", @".", @"+", @"", nil];
    }
    return _titleArr;
}
- (NSArray *)receiveMoenyArr {
    if (!_receiveMoenyArr) {
        self.receiveMoenyArr = [NSArray arrayWithObjects:@"扫码收款", @"二维码收款", nil];
    }
    return _receiveMoenyArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(238, 239, 241);
        // 添加选择收款方式按钮
        [self addReceiveMoenyButton];
        
        self.num1 = 0;
        self.num2 = 0;
        self.resultNum = 0;
        self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = RGB(179, 179, 179);
        [self addSubview:bgView];
        self.bgView = bgView;
        [self addNumPad];
    }
    return self;
}

// 添加选择收款方式按钮
- (void)addReceiveMoenyButton {
    JKConsumeButton *receiveBtn1 = [[JKConsumeButton alloc] init];
    receiveBtn1.tag = 1;
    receiveBtn1.selected = YES;
    receiveBtn1.title = @"扫码收款";
    receiveBtn1.frame = CGRectMake(0, 0, self.width * 0.5, 60);
    [receiveBtn1 addTarget:self action:@selector(receiveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:receiveBtn1];
    self.receiveBtn1 = receiveBtn1;
    
    JKConsumeButton *receiveBtn2 = [[JKConsumeButton alloc] init];
    receiveBtn2.tag = 2;
    receiveBtn2.title = @"二维码收款";
    receiveBtn2.frame = CGRectMake(self.width * 0.5, 0, self.width * 0.5, 60);
    [receiveBtn2 addTarget:self action:@selector(receiveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:receiveBtn2];
    
    self.receiveBtn2 = receiveBtn2;
}

- (void)receiveBtnClicked:(UIButton *)button {
    
    if (button.tag == 1) {
        
        self.receiveBtn1.selected = YES;
        self.receiveBtn2.selected = NO;
        NSLog(@"扫码收款");
    } else {
        self.receiveBtn1.selected = NO;
        self.receiveBtn2.selected = YES;
        NSLog(@"二维码收款");
    }
}

- (void)addNumPad {
    
    //    int column = column;// 列数
    int rowNum = (int)self.titleArr.count / column;
    NSLog(@"rowNum--%d", rowNum);
    CGFloat buttonW = (self.width - 3 * margin)/4;
    CGFloat buttonH = 0;
    if (iPhone4) {
        buttonH = buttonW - 15;
    } else {
        buttonH = buttonW;
    }
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        // 计算行号和列号
        int row = i / column;
        int col = i % column;
        
        CGFloat buttonX = buttonW * col + margin * col;
        self.buttonY = (buttonH * row) + margin * row;
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(buttonX, self.buttonY, buttonW, buttonH);
        button.tag = i;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        if (col == 3) {
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [self setButtonBackgroundImageWithButton:button normalName:@"padBg_functionKey_normal" selectedName:@"padBg_functionKey_selected"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [self setButtonBackgroundImageWithButton:button normalName:@"padBg_normal" selectedName:@"padBg_selected"];
        }

        
        [button addTarget:self action:@selector(numPadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
        if (i == 14) {
            self.button = button;// 加号按钮
        }
    }
    
    
    UIView *showNumView = [[UIView alloc] init];
    showNumView.backgroundColor = [UIColor whiteColor];
    showNumView.frame = CGRectMake(0, CGRectGetMaxY(self.receiveBtn1.frame) + 10, self.width, self.height - (CGRectGetMaxY(self.receiveBtn1.frame) + 10 + buttonH * rowNum));
    [self addSubview:showNumView];
    
    //创建标签
    CGFloat labelH = 60;
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, showNumView.height - labelH, showNumView.width - 15, labelH)];
    self.label.textColor=RGB(51, 51, 51);         //字体颜色
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.font=[UIFont systemFontOfSize:40];    //设置字体
    self.label.text = @"0";
    [showNumView addSubview:self.label];
    
    self.bgView.frame = CGRectMake(0, self.height - buttonH * rowNum, self.width, buttonH * rowNum);
    
    // 等于或收款收款按钮
    UIButton *receiveMoneyButton = [[UIButton alloc] init];
    receiveMoneyButton.frame = CGRectMake((buttonW + margin)*3, (buttonH + margin)*2, buttonW, buttonH * 2 + margin);
    [self setButtonBackgroundImageWithButton:receiveMoneyButton normalName:@"padBg_functionKey_normal" selectedName:@"padBg_functionKey_selected"];
    receiveMoneyButton.tag = 16;
    [receiveMoneyButton setTitle:@"收款" forState:UIControlStateNormal];
    [receiveMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    receiveMoneyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    receiveMoneyButton.backgroundColor = RGB(53, 149, 255);
    [receiveMoneyButton addTarget:self action:@selector(numPadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:receiveMoneyButton];
    self.receiveMoneyButton = receiveMoneyButton;
}

// 改变加号背景的状态
- (void)changePlusButtonSelectedState {
    
    if (self.button.tag == 14) {
        [self.button setBackgroundImage:[UIImage resizedImage:@"Images.bundle/padBg_normal"] forState:UIControlStateNormal];
    }
}

// 键盘的点击事件
- (void)numPadButtonClicked:(UIButton *)button {
    
    int buttonNum = button.tag % column;
    
    if (buttonNum != 3 && button.tag != 12 && button.tag != 13 && button.tag != 14 && button.tag != 16) {// 数字输入
        
        [self continuousNumWithNumButton:button];// 数字连续输入并显示数值
    }
    
    if (button.tag == 3) {// 后退

        [self back];
    }
    
    if (button.tag == 7) {// 清空
        [self clean];
    }
    
    if (button.tag == 16) {// 收款或等于号
        
        NSLog(@"self.receiveMoneyButton--%@",self.receiveMoneyButton.titleLabel.text);
        if ([self.receiveMoneyButton.titleLabel.text isEqualToString:@"="]) { // 按钮显示的是等于号
            self.receiveMoneyButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.receiveMoneyButton setTitle:@"收款" forState:UIControlStateNormal];
            
            if (self.resultNum != 0) {
                self.num1 = self.resultNum;
            }
            
            self.num2 = [self.string doubleValue];
            self.resultNum = self.num2 + self.num1;
            NSLog(@"self.num2--%f",self.num2);
            self.string = [NSMutableString stringWithFormat:@"%.2f", self.resultNum];
            self.label.text = self.string;
            [self countNumWihtShowLabelString];
            [self.string setString:@""];
            self.plusIsClicked = NO;
        } else { //按钮显示的是收款
            NSMutableString *inputString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", [self.label.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
            NSLog(@"self.label.text doubleValue--%f", [inputString doubleValue]);
            if ([inputString doubleValue] >= maxFund) {
                NSLog(@"超出限额");
            } else {
                if (self.receiveBtn1.isSelected) {
                    NSLog(@"扫码收款");
                    self.type = JKConsumePadTypeTypeScan;
                    if ([self.delegate respondsToSelector:@selector(consumeNumPadScanType:fund:)]) {
                        [self.delegate consumeNumPadScanType:self.type fund:self.label.text];
                    }
                }
                
                if (self.receiveBtn2.isSelected) {
                    NSLog(@"二维码收款");
                    self.type = JKConsumePadTypeTypeQRcode;
                    if ([self.delegate respondsToSelector:@selector(consumeNumPadScanType:fund:)]) {
                        [self.delegate consumeNumPadScanType:self.type fund:self.label.text];
                    }
                }
            }
        }
    }
    
    if (button.tag == 12) {// 数字0输入
        [self zeroInput:button];
    }
    
    if (button.tag == 13) {// 小数点输入
        [self pointInput:button];
    }
    
    if (button.tag == 14) {// 加号
        
        self.plusIsClicked = YES;
        
        self.num1 = 0;
        self.num1 = [self.string doubleValue]; // 输入的第一个数字
        if (self.num1 != 0) {// 如果第一个数字不为零，将结果置空
            
            self.resultNum = self.resultNum + self.num1;
            self.string = [NSMutableString stringWithFormat:@"%.2f", self.resultNum];
            self.label.text = self.string;
            [self countNumWihtShowLabelString];
            [self.string setString:@""];
        }
        
        NSLog(@"self.num1--%f", self.num1);
        
        [button setBackgroundImage:[UIImage resizedImage:@"Images.bundle/padBg_selected"] forState:UIControlStateNormal];
        [self.string setString:@""];
        self.receiveMoneyButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [self.receiveMoneyButton setTitle:@"=" forState:UIControlStateNormal];
    }
    
    if (button.tag != 14 && button.tag != 3) {
        [self changePlusButtonSelectedState];
    }
}

//后退
- (void)back {
    if (![self.string isEqualToString:@""]){//判断不是空
        [self.string deleteCharactersInRange:NSMakeRange([self.string length]-1,1)];//删除最后一个字符
        
        if ([self.string isEqualToString:@""]) {// 如果字符串为空，将label的text置为0
            self.label.text = @"0";
        } else {
            self.label.text=[NSString stringWithString:_string];//显示结果
        }
        
        [self countNumWihtShowLabelString];
    }
}

// 清除
- (void)clean {
    [self.string setString:@""];//清空字符
    self.resultNum = 0;
    self.resultAddNum = 0;
    self.label.text=@"0";//保证下次输入时清零
    
    if ([self.receiveMoneyButton.titleLabel.text isEqualToString:@"="]) { // 按钮显示的是等于号
        self.receiveMoneyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.receiveMoneyButton setTitle:@"收款" forState:UIControlStateNormal];
    }
}

// 小数点输入
- (void)pointInput:(UIButton *)button {
    NSLog(@"self.label.text--%@", self.label.text);
    if ([self.label.text isEqualToString:@"0"]) {
        self.string = [NSMutableString stringWithString:self.label.text];
    }
    
    if ([self.label.text rangeOfString:@"."].location == NSNotFound) {// 判断输入内容包含小数点
        [self continuousNumWithNumButton:button];// 数字连续输入并显示数值
    }
    
}

// 数字0输入
- (void)zeroInput:(UIButton *)button {
    
    if ([self.label.text isEqualToString:@"0"]) {
        self.label.text = @"0";
    } else {
        [self continuousNumWithNumButton:button];// 数字连续输入并显示数值
    }
}

// 数字连续输入并显示数值
- (void)continuousNumWithNumButton:(UIButton *)button {
    
    if (!self.plusIsClicked) {
        self.resultNum = 0;
    }
    [button titleForState:UIControlStateNormal];
    if ([self.string rangeOfString:@"."].location != NSNotFound) {
        
        //判断小数点的位数
        NSRange ran = [self.label.text rangeOfString:@"."];
        if (self.label.text.length - ran.location <= 2) {
            
            [self.string appendString:[button currentTitle]];      //数字连续输入
            
            if ([self.string doubleValue] >= maxFund) {
                [self.string deleteCharactersInRange:NSMakeRange(self.string.length - 1, 1)];
                
                NSLog(@"超出限额");
            } else {
                self.label.text=[NSString stringWithString:_string];   //显示数值
            }
        } else {
            NSLog(@"您最多输入两位小数");
        }
    } else {
        
        [self.string appendString:[button currentTitle]];      //数字连续输入
        
        if ([self.string doubleValue] >= maxFund) {
            [self.string deleteCharactersInRange:NSMakeRange(self.string.length - 1, 1)];
            NSLog(@"deleteStr--%@", self.string);
            NSLog(@"超出限额");
        } else {
            self.label.text=[NSString stringWithString:_string];   //显示数值
        }
    }
    
    // 添加分隔符
    [self countNumWihtShowLabelString];
}

// 添加分隔符是否有小数点
- (void)countNumWihtShowLabelString {
    
    NSLog(@"[self.label.text doubleValue]--%f", [self.label.text doubleValue]);
    if ([self.label.text doubleValue] >= maxFund) {
        NSLog(@"超出限额");
    }
    
    // 添加分隔符
    if ([self.label.text rangeOfString:@"."].location == NSNotFound) {// 无小数点
        
        NSLog(@"ByReplacing--%@", self.label.text);
        self.label.text = [self countNumAndChangeformat:self.string];
    } else {// 有小数点
        
        self.label.text = [self pointWithCountNumAndChangeformat:self.string];
    }
}

// 有小数点时添加分隔符的处理方式
- (NSString *)pointWithCountNumAndChangeformat:(NSString *)num {
    
    NSString *str = @"";
    NSLog(@"有小数点string--%@", self.string);
    NSArray *array = [num componentsSeparatedByString:@"."];
    NSLog(@"array0-%@,array1-%@",array[0], array[1]);
    
    NSString *tempStr = [self countNumAndChangeformat:array[0]];
    str = [NSString stringWithFormat:@"%@.%@", tempStr, array[1]];
    return str;
}

// 添加分隔符
- (NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

// 设置按钮的背景图片
- (void)setButtonBackgroundImageWithButton:(UIButton *)button normalName:(NSString *)normalName selectedName:(NSString *)selectedName {
    [button setBackgroundImage:[UIImage resizedImage:[NSString stringWithFormat:@"Images.bundle/%@", normalName]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizedImage:[NSString stringWithFormat:@"Images.bundle/%@", selectedName]] forState:UIControlStateHighlighted];
}

@end
