//
//  YDSubscribeCell.m
//  百思不得姐
//
//  Created by cyz on 16/12/28.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDSubscribeCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "channels.h"

@interface YDSubscribeCell ()

@property(nonatomic, weak) UILabel *mainTitleLabel;
@property (nonatomic, weak) UILabel *subscribeCountLabel;
@property (nonatomic, weak) UIImageView *channelImageView;
@property (nonatomic, weak) UIButton *accessoryButton;

@end

@implementation YDSubscribeCell

- (UILabel *)mainTitleLabel
{
	if (!_mainTitleLabel) {
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.font = [UIFont systemFontOfSize:13];
		
		[self.contentView addSubview:titleLabel];
		_mainTitleLabel = titleLabel;
	}
	return _mainTitleLabel;
}

- (UILabel *)subscribeCountLabel
{
	if (!_subscribeCountLabel) {
		UILabel *detailLabel = [[UILabel alloc] init];
		detailLabel.font = [UIFont systemFontOfSize:11];
		detailLabel.textColor = [UIColor grayColor];
		
		[self.contentView addSubview:detailLabel];
		_subscribeCountLabel = detailLabel;
	}
	return _subscribeCountLabel;
}

- (UIImageView *)channelImageView
{
	if (!_channelImageView) {
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.contentMode = UIViewContentModeScaleToFill;
		
		[self.contentView addSubview:imageView];
		_channelImageView = imageView;
	}
	return _channelImageView;
}

- (UIButton *)accessoryButton
{
	if (!_accessoryButton) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.titleLabel.font = [UIFont systemFontOfSize:13];
		
		[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
		
		[button setTitle:@"+ 订阅" forState:UIControlStateNormal];
		[button setTitle:@"已订" forState:UIControlStateSelected];
		
		[self.contentView addSubview:button];
		_accessoryButton = button;
	}
	return _accessoryButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setupView];
	}
	
	return self;
}

/// 初始化页面布局
- (void)setupView
{
	UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
	[self.channelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.insets(padding);
		make.width.equalTo(self.channelImageView.mas_height);
	}];
	
	[self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.offset(7);
		make.left.equalTo(self.channelImageView.mas_right).insets(padding);
	}];
	
	[self.subscribeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.offset(-7);
		make.left.equalTo(self.mainTitleLabel);
	}];

	[self.accessoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
		
		make.centerY.offset(0);
		make.right.insets(padding);
	}];
}

- (void)setModel:(channels *)model
{
	_model = model;
	
	self.mainTitleLabel.text = model.name;
	self.subscribeCountLabel.text = model.bookcount;
	
	[self.channelImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"post-@"]];
	
	self.accessoryButton.selected = model.subscribe;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
