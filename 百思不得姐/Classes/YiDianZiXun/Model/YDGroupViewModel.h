//
//  YDGroupViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/28.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
@class channels;

@interface YDGroupViewModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
/// 总的频道（热门、商业职场...）
@property (nonatomic, strong) NSArray<channels*> *groupChannel;

/// 请求一点资讯的更多频道
+ (void)requestYDAllChannelViewModel:(void (^)(YDGroupViewModel *model))completion failture:(void (^)(NSError *error))failture;
@end
