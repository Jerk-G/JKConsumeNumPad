//
//  UIImage+ResizedImage.m
//  zheft
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 zheft. All rights reserved.
//

#import "UIImage+ResizedImage.h"

@implementation UIImage (ResizedImage)


+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
