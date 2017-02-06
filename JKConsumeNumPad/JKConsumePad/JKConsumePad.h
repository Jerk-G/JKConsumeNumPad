//
//  ZHTConsumeNumPad.h
//  ZheHuiTong
//
//  Created by apple on 16/12/7.
//  Copyright © 2016年 faNaiSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JKConsumePadType) {
    
    JKConsumePadTypeTypeScan = 0,
    JKConsumePadTypeTypeQRcode
};

@protocol JKConsumePadDelegate <NSObject>

/**
 *  点击按钮的代理方法
 */
- (void)consumeNumPadScanType:(JKConsumePadType)type fund:(NSString *)fund;

@end

@interface JKConsumePad : UIView
@property (nonatomic, weak) id <JKConsumePadDelegate> delegate;

@property (nonatomic, assign) JKConsumePadType type;
@end
