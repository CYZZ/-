//
//  BLEssenceVideoCell.h
//  百思不得姐
//
//  Created by cyz on 16/11/15.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class list;

@interface BLEssenceVideoCell : UITableViewCell
@property (nonatomic, strong) list *model;

/**
 点击播放按钮
 */
@property (nonatomic, copy) void (^playBLock)();


/**
 点击评论按钮触发的block
 */
@property (nonatomic, copy) void (^commentBlock)();


/**
 设置可重用标识符

 @param model 模型数据

 @return 返回标识符
 */
+ (NSString *)cellReuseIDWith:(list *)model;

@end
