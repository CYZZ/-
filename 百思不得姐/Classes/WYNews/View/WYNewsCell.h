//
//  WYNewsCell.h
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class listModel;

@interface WYNewsCell : UITableViewCell

@property (nonatomic, strong) listModel *model;

@property (nonatomic, copy) void (^rightBtnBlock)();

@end
