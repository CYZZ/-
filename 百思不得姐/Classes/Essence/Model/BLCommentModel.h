//
//  BLCommentModel.h
//  不得姐模型
//
//  Created by cyz on 16/11/05.
//  Copyright © 2016年 cyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmt.h"


@interface BLCommentModel : NSObject

@property (nonatomic, copy) NSString * author;
@property (nonatomic, strong) NSArray<cmt *> * data;
@property (nonatomic, strong) NSArray<cmt *> * hot;
@property (nonatomic, assign) NSInteger total;

+ (void)getCommentModelWith:(NSDictionary *)dic complection:(void (^)(BLCommentModel *commentModel))complection failure:(void (^)(NSError * error))failure;
@end
