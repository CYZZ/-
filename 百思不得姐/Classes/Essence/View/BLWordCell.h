//
//  BLWordCell.h
//  百思不得姐
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class list;

@interface BLWordCell : UITableViewCell
/// 头像
@property (nonatomic, weak) UIImageView *profileImageView;
/// 昵称
@property (nonatomic, weak) UILabel *nameLabel;
/// 通过审核时间
@property (nonatomic, weak) UILabel *createdTimeLabel;
/// 内容Label
@property (nonatomic, weak) UILabel *contentTextLabel;
/// 底部工具条
@property (nonatomic, weak) UIView *toolBar;
/// cell的模型
@property (nonatomic, strong) list *model;
/// 点击按钮的时候调用block
@property (nonatomic, copy) void (^buttonBlock)();


@end
