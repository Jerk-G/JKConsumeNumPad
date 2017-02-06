//
//  JKConsumeButton.m
//  JKConsumeNumPad
//
//  Created by apple on 2017/2/6.
//  Copyright © 2017年 jerky. All rights reserved.
//

#import "JKConsumeButton.h"
#import "UIView+ExtensionFrame.h"

#define RGB(r,g,b) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b /255.0 alpha:1.0])
#define RGBA(r,g,b,a) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b /255.0 alpha:a/1.0])

@interface JKConsumeButton()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JKConsumeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addControl];
    }
    return self;
}

- (void)addControl {
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleL];
    self.titleL = titleL;
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleL.text = self.title;
    
    self.titleL.frame = CGRectMake(0, 0, self.width, self.height - 3);
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.titleL.frame), self.width, 3);
    
    if (self.isSelected) {
        
        self.titleL.textColor = RGB(53, 149, 255);
        self.lineView.backgroundColor = RGB(52, 149, 255);
    } else {
        
        self.titleL.textColor = RGB(51, 51, 51);
        self.lineView.backgroundColor = [UIColor clearColor];
    }
}


@end
