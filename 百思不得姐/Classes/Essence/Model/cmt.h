//
//  cmt.h
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "user.h"

@interface cmt : NSObject

@property (nonatomic, copy) NSString * cmt_type;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * ctime;
@property (nonatomic, copy) NSString * data_id;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * like_count;
@property (nonatomic, copy) NSString * precid;
@property (nonatomic, strong) NSArray * precmt;
@property (nonatomic, copy) NSString * preuid;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, strong) user * user;
@property (nonatomic, copy) NSString * voicetime;
@property (nonatomic, copy) NSString * voiceuri;

@end
