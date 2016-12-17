//
//  WYDetailNewsVC.h
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listModel.h"
#import <ReactiveCocoa.h>

@interface WYDetailNewsVC : UIViewController

/**
 列表数据
 */
@property (nonatomic, strong) listModel *listModel;


/**
 下一个控制器的subject
 */
@property (nonatomic, strong) RACSubject *delegateSinal;

@end
