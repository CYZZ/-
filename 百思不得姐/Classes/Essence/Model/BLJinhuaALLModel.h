//
//  BLJinhuaALLModel.h
//  不得姐模型
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "user.h"
#import "cmt.h"
@interface info : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString * maxid;
@property (nonatomic, copy) NSString * maxtime;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString * vendor;

@end

@interface list : NSObject

//@property (nonatomic, copy) NSString * bimageuri;
//@property (nonatomic, copy) NSString * bookmark;
//@property (nonatomic, assign) NSInteger cache_version;
@property (nonatomic, copy) NSString * cai;
//@property (nonatomic, copy) NSString * cdn_img;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * ding;
@property (nonatomic, copy) NSString * favourite;
//@property (nonatomic, copy) NSString * gifFistFrame;
//@property (nonatomic, copy) NSString * hate;
//@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * ID;
//@property (nonatomic, copy) NSString * image0;
//@property (nonatomic, copy) NSString * image1;
//@property (nonatomic, copy) NSString * image2;
@property (nonatomic, copy) NSString * image_small;
//@property (nonatomic, copy) NSString * is_gif;
@property (nonatomic, copy) NSString * love;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * original_pid;
@property (nonatomic, copy) NSString * passtime;
@property (nonatomic, assign) NSInteger playcount;
@property (nonatomic, assign) NSInteger playfcount;
@property (nonatomic, copy) NSString * profile_image;
//@property (nonatomic, copy) NSString * repost;
//@property (nonatomic, copy) NSString * screen_name;
//@property (nonatomic, copy) NSString * status;
//@property (nonatomic, assign) NSInteger t;
//@property (nonatomic, copy) NSString * tag;
/// 内容
@property (nonatomic, copy) NSString * text;
//@property (nonatomic, copy) NSString * theme_id;
//@property (nonatomic, copy) NSString * theme_name;
//@property (nonatomic, copy) NSString * theme_type;
//@property (nonatomic, strong) NSArray * themes;
/** 最热评论数据 */
@property (nonatomic, strong) NSArray<cmt *> * top_cmt;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * user_id;
//@property (nonatomic, copy) NSString * videotime;
/// 视频播放地址
@property (nonatomic, copy) NSString * videouri;
//@property (nonatomic, copy) NSString * voicelength;
//@property (nonatomic, copy) NSString * voicetime;
//@property (nonatomic, copy) NSString * voiceuri;
//@property (nonatomic, copy) NSString * weixin_url;
//@property (nonatomic, copy) NSString * width;

/// 添加的参数用于判断是否已显示最热评论
@property (nonatomic, assign) BOOL expanded;
@end

@interface BLJinhuaALLModel : NSObject

@property (nonatomic, strong) info * info;
@property (nonatomic, strong) NSArray<list *> * list;

/**
 通过网络请求得到字典数据

 @param dic         传递参数
 @param complection 请求结束之后执行代码块
 @param failure     失败之后执行的代码块
 */
+ (void)getEssenceModelWith:(NSDictionary *)dic complection:(void (^)(BLJinhuaALLModel *ALLModel))complection failure:(void (^)(NSError * error))failure;

@end
