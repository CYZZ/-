//
//  BLSentMessageVC.h
//  百思不得姐
//
//  Created by cyz on 16/11/8.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLSentMessageVC : UIViewController

/**
 视频了链接
 */
@property (nonatomic, copy) NSString *videourl;


/**
 加载html字符串

 @param htmlString 字符串
 */
- (instancetype)initWithHtmlString:(NSString *)htmlString;
@end
