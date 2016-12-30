//
//  YidianhaoModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
@class subchannels;
@interface YidianhaoModel : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray<subchannels*> *channels;

@end
