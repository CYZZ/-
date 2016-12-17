//
//  result.h
//  一点资讯模型
//
//  Created by cyz on 16/12/13.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDresult : NSObject

@property (nonatomic, assign) BOOL auth;
@property (nonatomic, assign) BOOL b_native;
@property (nonatomic, assign) BOOL b_political;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString * content_type;
@property (nonatomic, copy) NSString * ctype;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, strong) NSArray * dislike_reasons;
@property (nonatomic, copy) NSString * docid;
@property (nonatomic, assign) NSInteger down;
@property (nonatomic, assign) NSInteger dtype;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, strong) NSArray * image_urls;
@property (nonatomic, copy) NSString * impid;
@property (nonatomic, assign) BOOL is_gov;
@property (nonatomic, copy) NSString * itemid;
@property (nonatomic, strong) NSArray * keywords;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, copy) NSString * meta;
@property (nonatomic, assign) NSInteger mtype;
@property (nonatomic, copy) NSString * pageid;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * source_channel;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, copy) NSString * tag_icon;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger up;
@property (nonatomic, copy) NSString * update_title_time;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * video_url;
@property (nonatomic, strong) NSArray * vsct;
@property (nonatomic, strong) NSArray * vsct_show;

@end
