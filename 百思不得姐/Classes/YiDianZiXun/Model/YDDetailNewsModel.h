//
//  YDDetailNewsModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YDDocumentModel;
@interface YDDetailNewsModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger code;
/// 资讯详情页模型数据
@property (nonatomic, strong) NSArray<YDDocumentModel*> *documents;

@end
