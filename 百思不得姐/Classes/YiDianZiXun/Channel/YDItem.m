//
//  YDItem.m
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDItem.h"

extern CGFloat const imageViewWH;

@implementation YDItem

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.imageView.frame.size.width <= 0) {
		return;
	}
	
	CGFloat btnW = self.bounds.size.width;
	CGFloat btnH = self.bounds.size.height;
	
	self.titleLabel.frame = CGRectMake(_margin, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
	
	CGFloat imageX = btnW - self.imageView.frame.size.width - _margin;
	self.imageView.frame = CGRectMake(imageX, (btnH - imageViewWH) / 2.0, imageViewWH, imageViewWH);
}

// 重写highlighted方法，让按钮高亮状态无效
- (void)setHighlighted:(BOOL)highlighted
{
	
}

@end
