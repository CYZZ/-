//
//  WYNewsDetailBottomView.m
//  百思不得姐
//
//  Created by cyz on 16/12/17.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYNewsDetailBottomView.h"

@interface WYNewsDetailBottomView ()
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WYNewsDetailBottomView


+ (instancetype)theBootomCloseView
{
	return [[[NSBundle mainBundle]loadNibNamed:@"WYNewsDetailBottomView" owner:nil options:nil] lastObject];
}

- (void)setIsCloseing:(BOOL)isCloseing
{
	_isCloseing = isCloseing;
	self.closeImageView.image = [UIImage imageNamed:isCloseing ? @"newscontent_drag_return" : @"newscontent_drag_arrow"];
	self.titleLabel.text = isCloseing ? @"松手关闭当前页" : @"上拉关闭当前页" ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
