//
//  UIButton+Extension.h
//  百思不得姐
//
//  Created by cyz on 16/11/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮点击回调block
 */
typedef void(^CompletionHandler)(UIButton *sender);

@interface UIButton (Extension)


/**
 使用Block返回按钮点击事件

 @param controlEvents 点击事件
 @param completion    回调block代码
 */
- (void)BL_addActionforControLEvents:(UIControlEvents)controlEvents respond:(CompletionHandler)completion;

@end
