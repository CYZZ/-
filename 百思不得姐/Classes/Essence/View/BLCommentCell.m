//
//  BLCommentCell.m
//  百思不得姐
//
//  Created by cyz on 16/11/5.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLCommentCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "BLCommentModel.h"

@interface BLCommentCell()

@property(nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nickLable;
@property (nonatomic, weak) UILabel *cmtLable;
@property (nonatomic, weak) UILabel *cmtCountLabel;

@end

@implementation BLCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mainCellBackground"]];
        [self setupView];
    }
    return self;
}

- (void) setupView 
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
    UILabel *nickLabel = [[UILabel alloc] init];
    self.nickLable = nickLabel;
    UILabel *cmtLable = [[UILabel alloc] init];
    self.cmtLable = cmtLable;
    UILabel *cmtCountLabel = [[UILabel alloc] init];
    self.cmtCountLabel = cmtCountLabel;
    UIImageView *dingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellDing"]];
    
    nickLabel.font = [UIFont systemFontOfSize:12];
    nickLabel.textColor = [UIColor lightGrayColor];
    cmtCountLabel.font = [UIFont systemFontOfSize:12];
    cmtCountLabel.textColor = [UIColor lightGrayColor];
    
    cmtLable.numberOfLines = 0;
    
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:nickLabel];
    [self.contentView addSubview:cmtLable];
    [self.contentView addSubview:cmtCountLabel];
    [self.contentView addSubview:dingImageView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(40);
        make.top.left.insets(padding);
    }];
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(iconImageView.mas_right).insets(padding);
    }];
    
    [cmtLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(-10);
        make.left.equalTo(iconImageView.mas_right).insets(padding);
        make.bottom.right.insets(padding);
    }];
    
    [dingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(padding);
        make.right.equalTo(cmtCountLabel.mas_left).insets(padding);
    }];
    
    [cmtCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.insets(padding);
    }];
}
- (void)setModel:(cmt *)model
{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString: model.user.profile_image] placeholderImage:[UIImage imageNamed:@"setup-head-default"] options:SDWebImageDelayPlaceholder | SDWebImageRetryFailed];
    
    _nickLable.text = model.user.username;
    _cmtLable.text = model.content;
    _cmtCountLabel.text = model.like_count;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc
{
//    NSLog(@"%s dealloc",__func__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
