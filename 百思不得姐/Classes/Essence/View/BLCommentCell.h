//
//  BLCommentCell.h
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class cmt;

@interface BLCommentCell : UITableViewCell
/// 评论模型
@property (nonatomic, strong) cmt *model;
@end
