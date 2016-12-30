//
//  YiDianHaoViewModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
@class subchannels;

@interface YiDianHaoViewModel : NSObject

+(void)requesYDHWithgroupID:(NSString *)groupID completion:(void (^)(NSArray<subchannels*> *channels))completion failture:(void (^)(NSError *error))failture;
@end
