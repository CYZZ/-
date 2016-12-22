//
//  YiDianChannelModel.h
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class user_channels;

@interface YiDianChannelModel : NSObject

@property (nonatomic, copy) NSString * appid;
@property (nonatomic, assign) long code;
@property (nonatomic, copy) NSString * fontsize;
@property (nonatomic, assign) BOOL freshuser;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * profile_url;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, strong) NSArray<user_channels *> * user_channels;
@property (nonatomic, assign) long userid;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * utk;
@property (nonatomic, copy) NSString * version;

/// 请求一点资讯的频道数据
+ (void)requestYDChannels:(void (^)(YiDianChannelModel *model))completion failture:(void (^)(NSError *error))failture;
@end
