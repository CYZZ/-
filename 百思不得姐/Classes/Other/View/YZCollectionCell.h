//
//  YZCollectionCell.h
//  百思不得姐
//
//  Created by cyz on 16/11/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class list;

@interface YZCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) void (^buttonBlock)();

/**
 CollectionCell的模型数据
 */
@property (nonatomic, strong) list *model;

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat heightForCell;

@end
