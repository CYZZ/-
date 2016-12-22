//
//  YiDianNewsModel.h
//  一点资讯模型
//
//  Created by cyz on 16/12/13.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDresult;

@interface YiDianNewsModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger fresh_count;
@property (nonatomic, strong) NSArray<YDresult *> * result;
@property (nonatomic, copy) NSString * search_hint;
@property (nonatomic, copy) NSString * status;

/**
  请求一点资讯数据

 @param cstart 上次加载位置
 @param position 频道所属位置
 @param channelID 频道ID
 @param completion 完成回调
 @param failture 失败回调
 */
+ (void)requestYDNewsWith:(NSInteger)cstart position:(NSInteger)position channelID:(NSString *)channelID forNews:(void (^)(YiDianNewsModel *model))completion failture:(void (^)(NSError *error))failture;

@end
