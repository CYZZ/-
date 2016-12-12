//
//  YZWaterFlowLayout.h
//  百思不得姐
//
//  Created by cyz on 16/11/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZWaterFlowLayout;
// 创建代理方法
@protocol YZWaterFlowLayoutDelegate<NSObject>
@required

/**
 初始化高度
 
 @param waterflowLayout 布局
 @param collectionView  所属的collectionView
 @param indexPath       索引
 @param itemWidth       宽度

 @return 高度
 */
- (CGFloat)waterflowLayout:(YZWaterFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/// 列数
- (CGFloat)columnCountInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout;
/// 列间距
- (CGFloat)columnMarginInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout;
/// 行间距
- (CGFloat)rowMarginInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout;
/// item的上下左右间距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(YZWaterFlowLayout *)waterflowLayout;

@end


@interface YZWaterFlowLayout : UICollectionViewLayout
/// 流式布局的代理方法
@property (nonatomic, weak) id<YZWaterFlowLayoutDelegate> delegate;

@end
