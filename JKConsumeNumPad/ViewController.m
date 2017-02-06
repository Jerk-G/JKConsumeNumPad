//
//  ViewController.m
//  JKConsumeNumPad
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 jerky. All rights reserved.
//

#import "ViewController.h"
#import "JKConsumePad.h"
#import "UIView+ExtensionFrame.h"

@interface ViewController ()<JKConsumePadDelegate>
@property (nonatomic, strong) NSString *string;// 存放输入的金额
@property (nonatomic, strong) JKConsumePad *consumePad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加输入键盘
    [self addConsumeNumPad];
}

// 添加输入键盘
- (void)addConsumeNumPad {
    
    JKConsumePad *consumePad = [[JKConsumePad alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    consumePad.delegate = self;
    [self.view addSubview:consumePad];
    self.consumePad = consumePad;
}

#pragma mark - ZHTConsumeNumPadDelegate(输入键盘的代理)
- (void)consumeNumPadScanType:(JKConsumePadType)type fund:(NSString *)fund {
    
    NSMutableString *inputString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", [fund stringByReplacingOccurrencesOfString:@"," withString:@""]]];
    // 如果最后一位是小数点，小数点后补两个0
    if ([inputString  hasSuffix:@"."]) {
        inputString = [NSMutableString stringWithFormat:@"%@00", inputString];
    }
    
    // 如果输入的金额无小数点，补全小数点后位数
    if ([inputString rangeOfString:@"."].location == NSNotFound) {
        inputString = [NSMutableString stringWithFormat:@"%@.00", inputString];
    }
}


@end
