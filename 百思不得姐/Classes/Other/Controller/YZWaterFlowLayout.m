//
//  YZWaterFlowLayout.m
//  百思不得姐
//
//  Created by cyz on 16/11/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YZWaterFlowLayout.h"
/// 默认的列数
static const NSInteger YZDefaultColumnCount = 3;
/// 默认的列间距
static const CGFloat YZDefaultColumnMargin = 10;
/// 默认的行间距
static const CGFloat YZDefaultRowMarGin = 10;
/// 默认的边缘间距
static const UIEdgeInsets YZDefaultEdgeInsets = {10, 10, 10, 10};

@interface YZWaterFlowLayout ()
/// 存放所有的布局属性
@property (nonatomic, strong)NSMutableArray *attrsArray;
/// 存放所有列的当前高度
@property (nonatomic, strong) NSMutableArray *columnHeights;
/// 内容的高度
@property (nonatomic, assign) CGFloat contentHeight;


#pragma mark - 在这里先声明就能调用点语法访问get方法
/// 行间距
- (CGFloat)rowMargin;
/// 列间距
- (CGFloat)columnMargin;
/// 数量
- (NSInteger)columnCount;
/// 外边距
- (UIEdgeInsets)edgeInsets;
@end

@implementation YZWaterFlowLayout

#pragma mark - 常见的数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return YZDefaultRowMarGin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) 
    {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return YZDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) 
    {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else{
        return YZDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) 
    {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else{
        return YZDefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - 重写系统的方法开始布局样式
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清除以前的计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 开始创建每一个cell对应的布局属性（只对第一组)
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
//        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        NSInteger count = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger i = 0; i < count; i++) {
            // 创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            // 获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
    }
    
}

/// 决定cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/// 返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
   
    CGFloat h = [self.delegate waterflowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:w];
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短的那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end










