//
//  YiDianhaoCell.m
//  百思不得姐
//
//  Created by cyz on 16/12/30.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YiDianhaoCell.h"
#import <Masonry.h>
#import "subchannels.h"
#import "YDArticlelist.h"
#import <UIImageView+WebCache.h>

@interface YiDianhaoCell ()
@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *categoryLabel;

@end

@implementation YiDianhaoCell

- (UIImageView *)headImageView
{
	if (!_headImageView) {
		UIImageView *imageView = [[UIImageView alloc] init];
		_headImageView = imageView;
		[self.contentView addSubview:imageView];
	}
	return _headImageView;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		UILabel *label = [[UILabel alloc] init];
		_titleLabel = label;
		[self.contentView addSubview:label];
		label.font = [UIFont systemFontOfSize:13];
	}
	return _titleLabel;
}

- (UILabel *)detailLabel
{
	if (!_detailLabel) {
		UILabel *label = [[UILabel alloc] init];
		_detailLabel = label;
		[self.contentView addSubview:label];
		_detailLabel.font = [UIFont systemFontOfSize:10];
		_detailLabel.textColor = [UIColor grayColor];
	}
	return _detailLabel;
}

- (UILabel *)timeLabel
{
	if (!_timeLabel) {
		UILabel *label = [[UILabel alloc] init];
		_timeLabel = label;
		[self.contentView addSubview:label];
		_timeLabel.font = [UIFont systemFontOfSize:9];
		_timeLabel.textColor = [UIColor grayColor];
	}
	return _timeLabel;
}

- (UILabel *)categoryLabel
{
	if (!_categoryLabel) {
		UILabel *label = [[UILabel alloc] init];
		_categoryLabel = label;
		[self.contentView addSubview:label];
		label.font = [UIFont systemFontOfSize:9];
	}
	return _categoryLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setupView];
	}
	return self;
}

/// 布局
- (void)setupView
{
	UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.insets(padding);
		make.height.equalTo(self.headImageView.mas_width);
	}];
	
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.insets(padding);
		make.left.equalTo(self.headImageView.mas_right).insets(padding);
	}];
	
	[self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.titleLabel);
		make.bottom.insets(padding);
	}];
	
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.titleLabel);
		make.right.equalTo(self.categoryLabel.mas_left).insets(padding);
	}];
	[self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.titleLabel);
		make.right.insets(padding);
	}];
}

- (void)setModel:(subchannels *)model
{
	_model = model;
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"post-@"]];
	self.titleLabel.text = model.name;
	self.detailLabel.text = model.articlelist.title;
	self.timeLabel.text = model.articlelist.date;
	self.categoryLabel.text = model.category;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
