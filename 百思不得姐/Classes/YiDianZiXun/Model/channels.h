//
//  channels.h
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class subchannels;

@interface channels : NSObject

@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * channel_id;
@property (nonatomic, copy) NSString * checksum;
@property (nonatomic, copy) NSString * fromId;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * share_id;
@property (nonatomic, strong) NSArray<subchannels *> * subchannels;
/// 频道分类中包含频道（添加频道页面使用）
@property (nonatomic, strong) NSArray<channels *> * channels;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString *ID;
/// 订阅数
@property (nonatomic, strong) NSString *bookcount;
/// 是否已订阅
@property (nonatomic, assign,getter=isSubscripbe) BOOL subscribe;

@end
