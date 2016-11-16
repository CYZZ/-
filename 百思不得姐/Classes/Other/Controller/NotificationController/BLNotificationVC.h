//
//  BLNotificationVC.h
//  百思不得姐
//
//  Created by cyz on 16/11/7.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  通知跳转的控制器 */
@interface BLNotificationVC : UIViewController


/**
 初始化创建一个wkwebView

 @param URL webView的url
 */
- (instancetype)initWithWkwebView:(NSString *)URL;

@end
