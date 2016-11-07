//
//  BLRefreshFooter.m
//  百思不得姐
//
//  Created by cyz on 16/10/27.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLRefreshFooter.h"

@implementation BLRefreshFooter

- (void)prepare
{
    [super prepare];
    self.triggerAutomaticallyRefreshPercent = -20;
    [self setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
//    
//    /** 普通闲置状态 */
//    MJRefreshStateIdle = 1,
//    /** 松开就可以进行刷新的状态 */
//    MJRefreshStatePulling,
//    /** 正在刷新中的状态 */
//    MJRefreshStateRefreshing,
//    /** 即将刷新的状态 */
//    MJRefreshStateWillRefresh,
//    /** 所有数据加载完毕，没有更多的数据了 */
//    MJRefreshStateNoMoreData
}

@end
