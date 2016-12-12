//
//  WYNewsModel.h
//  不得姐模型
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class listModel;

@interface WYNewsModel : NSObject

@property (nonatomic, strong) NSArray<listModel *> *list;


/**
 获取获取网易新闻数据

 @param commplet 完成回调
 @param failture 失败回调
 */
+ (void)request:(NSString*)url ForWYNews:(void(^)(WYNewsModel *model))commplet failture:(void(^)(NSError *error))failture;

@end
