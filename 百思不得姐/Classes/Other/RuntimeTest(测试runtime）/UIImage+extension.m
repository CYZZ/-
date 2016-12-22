//
//  UIImage+extension.m
//  百思不得姐
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "UIImage+extension.h"
#import <objc/runtime.h>

// 定义关联的key
static const char *key = "name";
@implementation UIImage (extension)

// 加载分类到内存的时候就交换两个放
+ (void)load
{
	// 交换方法
	// 获取imageWithName方法地址
	Method imageWithName =  class_getClassMethod(self, @selector(imageWithName:));
	
	// 获取imageName方法地址
	Method imageName = class_getClassMethod(self, @selector(imageNamed:));
	
	// 交换方法地址，相当于狡猾年实现方式
	method_exchangeImplementations(imageWithName, imageName);
}

// 不能再分中重写系统方法imageNamed，因为会吧系统的功能给覆盖掉，而且分类中不能吊阴功super

// 既能加载图片又能打印
+ (instancetype)imageWithName:(NSString *)name
{
	// 这里的imageWithName，相当于调用imageName
	UIImage *image = [self imageWithName:name];
	
	if (image == nil) {
		NSLog(@"加载空图片");
	
	}
	
	return image;
}

// 动态添加属性(给分类添加属性)
// get方法
- (NSString *)name
{
	// 根据关联的key，获取关联的值
	return objc_getAssociatedObject(self, key);
}

// set方法
- (void)setName:(NSString *)name
{
	// 第一个参数：给哪个对象添加关联
	// 第二个参数：关联的key，通过这个key获取
	// 第三个参数：管理啊你的value
	// 第四个参数：管理啊你的策略
	objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
