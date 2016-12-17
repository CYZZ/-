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
 请求一点资讯的数据

 @param cstart 上次请求资讯的位置
 @param completion 回调数据
 */
+ (void)requestYDNewsWith:(NSInteger)cstart forNews:(void(^)(YiDianNewsModel *model))completion failture:(void (^)(NSError *error))failture;

@end
