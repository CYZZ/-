//
//  WYNewsDetailBottomView.h
//  百思不得姐
//
//  Created by cyz on 16/12/17.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYNewsDetailBottomView : UIView
/// 是否关闭当前页面
@property (nonatomic, assign) BOOL isCloseing;
/// 获取底部显示的控件
+ (instancetype)theBootomCloseView;
@end
