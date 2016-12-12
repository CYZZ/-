//
//  T1348649145984.h
//  不得姐模型
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WYNewsDetailEntity;

@interface listModel : NSObject


@property (nonatomic, copy) NSString * TAG;
@property (nonatomic, copy) NSString * TAGS;
@property (nonatomic, copy) NSString * alias;
@property (nonatomic, copy) NSString * boardid;
@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * digest;
@property (nonatomic, copy) NSString * docid;
@property (nonatomic, copy) NSString * ename;
@property (nonatomic, assign) BOOL hasAD;
@property (nonatomic, assign) BOOL hasCover;
@property (nonatomic, assign) BOOL hasHead;
@property (nonatomic, strong) NSString * hasIcon;
@property (nonatomic, assign) BOOL hasImg;
@property (nonatomic, copy) NSString * imgsrc;
@property (nonatomic, assign) NSInteger imgsum;
@property (nonatomic, copy) NSString * lmodify;
@property (nonatomic, copy) NSString * ltitle;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString * photosetID;
@property (nonatomic, copy) NSString * postid;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, copy) NSString * ptime;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, copy) NSString * skipID;
@property (nonatomic, copy) NSString * skipType;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * wytemplate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * tname;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * url_3w;
@property (nonatomic, assign) NSInteger votecount;

@property (nonatomic, strong) WYNewsDetailEntity *detailModel;


@end
