//
//  subchannels.h
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YDArticlelist;
@interface subchannels : NSObject

@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * channel_id;
@property (nonatomic, copy) NSString * checksum;
@property (nonatomic, copy) NSString * fromId;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * share_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * updateTime;

@property (nonatomic, strong) YDArticlelist *articlelist;
@end
