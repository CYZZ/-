//
//  user_channels.h
//  一点资讯模型
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class channels;

@interface user_channels : NSObject

@property (nonatomic, copy) NSString * bgcolor;
@property (nonatomic, copy) NSString * channel_id;
@property (nonatomic, strong) NSArray<channels *> * channels;
@property (nonatomic, copy) NSString * checksum;
@property (nonatomic, assign) BOOL deletable;
@property (nonatomic, assign) BOOL doc_bookable;
@property (nonatomic, copy) NSString * fakechannel_type;
@property (nonatomic, copy) NSString * fromId;
@property (nonatomic, copy) NSString * group_id;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * icon_highlight;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * min_version;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray * override_;
@property (nonatomic, copy) NSString * share_id;
@property (nonatomic, copy) NSString * title_icon;
@property (nonatomic, copy) NSString * titlecolor;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * updateTime;

@end
