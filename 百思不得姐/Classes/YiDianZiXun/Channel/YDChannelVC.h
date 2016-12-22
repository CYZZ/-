//
//  YDChannelVC.h
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "channels.h"

@interface YDChannelVC : UIViewController
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray<channels *> *channeslArr;
/// 频道组回调
@property (nonatomic, copy) void(^channelBackBlock)(NSMutableArray<channels*> *channeslArr);

/// 选中频道时调用block
@property (nonatomic, copy) void(^selectChannel)(NSString *str);
@end
