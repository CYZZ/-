//
//  BLNightMode.h
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNetworkTool.h"

@interface BLNightMode : NSObject

@property (nonatomic, assign) BOOL night;
+ (instancetype)sharedTool;
@end
