//
//  BLPerson.m
//  百思不得姐
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLPerson.h"
#import <objc/runtime.h>


@implementation BLPerson

// 默认会有两个隐式参数
//void eat(id self, SEL sel)
//{
//	NSLog(@"%@, %@", self,NSStringFromSelector(sel));
//}
//
//// 当一个对象对用未实现的方法，会调用这个方法处理，并且会吧对应的方法列表传过来。
//// 刚好可以用来判断，为实现的方法是不是我们想要动态添加的方法
//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//	if (sel == @selector(eat)) {
//		// 动态调用eat方法
//		
//		// 第一个参数：给哪个类添加方法
//		// 第二个参数：添加的方法编号
//		// 第三个参数：添加方法的函数实现（函数地址）
//		// 第四个参数：函数的类型，（返回值+参数）v:void @:对象->self：表示SEL->_cmd
//		class_addMethod(self, @selector(eat), eat, "v@:");
//	}
//	
//	return [super resolveClassMethod:sel];
//}



@end
