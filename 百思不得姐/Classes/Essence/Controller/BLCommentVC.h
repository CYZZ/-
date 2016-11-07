//
//  BLCommentVC.h
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLCommentVC : UIViewController

/**
 传递ID创建一个控制器

 @param ID 帖子ID
 */
- (instancetype)initWithCommentID:(NSString *)ID;
@end
