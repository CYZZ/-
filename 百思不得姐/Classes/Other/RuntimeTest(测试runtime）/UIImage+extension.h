//
//  UIImage+extension.h
//  百思不得姐
//
//  Created by cyz on 16/12/20.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)
+ (instancetype)imageWithName:(NSString *)name;

- (NSString *)name;

- (void)setName:(NSString *)name;

@end
