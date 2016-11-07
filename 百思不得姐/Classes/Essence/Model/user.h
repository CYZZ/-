//
//  user.h
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, assign) BOOL is_vip;
@property (nonatomic, copy) NSString * personal_page;
@property (nonatomic, copy) NSString * profile_image;
@property (nonatomic, copy) NSString * qq_uid;
@property (nonatomic, copy) NSString * qzone_uid;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * total_cmt_like_count;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * weibo_uid;

@end
