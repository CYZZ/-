//
//  BLRefreshHeader.m
//  百思不得姐
//
//  Created by cyz on 16/10/27.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLRefreshHeader.h"

@implementation BLRefreshHeader

///** 普通闲置状态 */
//MJRefreshStateIdle = 1,
///** 松开就可以进行刷新的状态 */
//MJRefreshStatePulling,
///** 正在刷新中的状态 */
//MJRefreshStateRefreshing,
///** 即将刷新的状态 */
//MJRefreshStateWillRefresh,
///** 所有数据加载完毕，没有更多的数据了 */
//MJRefreshStateNoMoreData

/**
 初始化
 */
- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"下拉即可刷新👎" forState:MJRefreshStateIdle];
    [self setTitle:@"松开立即刷新👍" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新数据中😜" forState:MJRefreshStateRefreshing];
}


/**
 摆放子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];
}
@end
