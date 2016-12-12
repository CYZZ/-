//
//  WYNewsDetailEntity.h
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bodyimg : NSObject

/**  图片链接 */
@property (nonatomic, copy) NSString *src;
/// 图片描述
@property (nonatomic, copy) NSString *alt;
/// 图片尺寸
@property (nonatomic, copy) NSString *pixel;
/// 图片位置
@property (nonatomic, copy) NSString *ref;

@end

/**
 内容部分模型
 */
@interface WYNewsDetailEntity : NSObject
/// 文章标题
@property (nonatomic, copy) NSString *title;
/// 内容
@property (nonatomic, copy) NSString *body;
/// 图片数组
@property (nonatomic, strong) NSArray<bodyimg *> *img;
/// 回复数
@property (nonatomic, copy) NSString *replayCount;

@end
