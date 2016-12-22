//
//  YDTagView.h
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDItem.h"
/// 高度或跟随标题数量自动计算高度，默认标签胡自动计算宽度
@interface YDTagView : UIView

/// 删除按钮显示的图片
@property (nonatomic, strong) UIImage *tagDeleteImage;
/// 标签之间的间距，上下间距和左右间距，默认是10
@property (nonatomic, assign) CGFloat tagMargin;
/// 标签颜色，默认是红色
@property (nonatomic, strong) UIColor *tagColor;
/// 背景颜色
@property (nonatomic, strong) UIColor *tagBackgroundColor;
/// 背景图片
@property (nonatomic, strong) UIImage *tagBackgroundImage;
/// 标签字体大小，默认是13号
@property (nonatomic, assign) UIFont *tagFont;
/// 内边距
@property (nonatomic, assign) CGFloat contentMargin;
/// 圆角弧度默认是5
@property (nonatomic, assign) CGFloat tagCornerRadius;
/// 视图的高度
@property (nonatomic, assign) CGFloat contentHeight;
/// 标签的边框宽度
@property (nonatomic, assign) CGFloat tagBorderWidth;
/// 标签的边框颜色
@property (nonatomic, strong) UIColor *tagBorderColor;
/// 所有标签
@property (nonatomic, strong, readonly) NSMutableArray *tagArrays;
/// 是否需要自定义View的高度，默认是YES
@property (nonatomic, assign) BOOL isFitTagViewH;
/// 是否需要排序功能
@property (nonatomic, assign) BOOL isSort;
/// 在排序的时候被选中的标签放大比例，需要大于1
@property (nonatomic, assign) CGFloat scaleTagInSort;
/// 自定义标签按钮, 需要继承自YDItem
@property (nonatomic, strong) YDItem *item;
/// 自定义标签的尺寸
@property (nonatomic, assign) CGSize tagSize;
/// 标签列表列数，默认是4列
@property (nonatomic, assign) NSUInteger tagListCols;
/// 被忽略的标签数（头N个的标签不允许移动）
@property (nonatomic, assign) NSUInteger ignoreSortCount;

/**
 添加标签

 @param tagStr 标签文字
 */
- (void)addTag:(NSString *)tagStr;

/**
 添加标签数组

 @param tagStrs 数组
 */
- (void)addTags:(NSArray<NSString *> *)tagStrs;


/**
 删除标签

 @param tagStr 标签文字
 */
- (void)deleteTag:(NSString *)tagStr;

/// 点击标签按钮之后触发的方法
@property (nonatomic, copy) void(^clickTagBlock)(NSString *tag);

@property (nonatomic, copy) void(^exchangeItemsBlock)(NSInteger index1, NSInteger index2);
/**
 并不是交换两个索引位置，其实是先删除后插入

 @param change 被交换的block
 */
- (void)exchangeItemsBetween:(void(^)(NSInteger index1, NSInteger index2))change;

@end
