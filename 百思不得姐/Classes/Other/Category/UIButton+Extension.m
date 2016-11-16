


//
//  UIButton+Extension.m
//  百思不得姐
//
//  Created by cyz on 16/11/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

static void *const ButtonClkickKey = @"ButtonClickKey";

@implementation UIButton (Extension)

- (void)BL_addActionforControLEvents:(UIControlEvents)controlEvents respond:(CompletionHandler)completion
{
    // 使用runtime进行赋值
    objc_setAssociatedObject(self, ButtonClkickKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(btnClick:) forControlEvents:controlEvents];
}

- (void)btnClick:(UIButton *)sender
{
    // 使用runtime取值
    void (^block)(UIButton *sender) = objc_getAssociatedObject(self, ButtonClkickKey);
    // 调用block
    block(sender);
}

@end
