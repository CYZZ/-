//
//  BLWordCell.m
//  百思不得姐
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLWordCell.h"
#import "BLJinhuaALLModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface BLWordCell ()

@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UILabel *hotLabel;
@property (nonatomic, weak) UILabel *top_cmt;
@property (nonatomic, weak) UIButton *dingBtn;
@property (nonatomic, weak) UIButton *caiBtn;
@property (nonatomic, weak) UIButton *shareBtn;
@property (nonatomic, weak) UIButton *cmtBtn;
/// 内容的bottom约束
@property (strong, nonatomic) MASConstraint *contentLabelBottomConstraint;
@property (strong, nonatomic) MASConstraint *hotLabelBottomConstraint;

@end

@implementation BLWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mainCellBackground"]];
        [self setupView];
    }
    return self;
}

/**
 初始化View的布局
 */
- (void)setupView 
{
    UIImageView *profileImageView = [[UIImageView alloc] init];
    self.profileImageView = profileImageView;
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    UILabel *createdTimeLabel = [[UILabel alloc] init];
    self.createdTimeLabel = createdTimeLabel;
    UILabel *contentTextLabel = [[UILabel alloc] init];
    self.contentTextLabel = contentTextLabel;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    UILabel *hotLabel = [[UILabel alloc] init];
    self.hotLabel = hotLabel;
    UILabel *top_cmt = [[UILabel alloc] init];
    self.top_cmt = top_cmt;
    UIView *toolBar = [[UIView alloc] init];
    self.toolBar = toolBar;
    UIButton *dingBtn = [self creatBtnWithImagge:@"mainCellDing" title:@"顶"];
    self.dingBtn = dingBtn;
    UIButton *caiBtn = [self creatBtnWithImagge:@"mainCellCai" title:@"踩"];
    self.caiBtn = caiBtn;
    UIButton *shareBtn = [self creatBtnWithImagge:@"mainCellShare" title:@"分享"];
    self.shareBtn = shareBtn;
    UIButton *cmtBtn = [self creatBtnWithImagge:@"mainCellComment" title:@"评论"];
    self.cmtBtn = cmtBtn;
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-button-line"]];
    
    
    
    nameLabel.font = [UIFont systemFontOfSize:14];
    createdTimeLabel.font = nameLabel.font;
    
//    button.enabled = NO;
    [button setTitle:@"展开最热评论" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    hotLabel.text = @"最热评论:";
    hotLabel.textColor = [UIColor whiteColor];
    hotLabel.backgroundColor = [UIColor lightGrayColor];
    
    top_cmt.textColor = [UIColor lightGrayColor];
    top_cmt.numberOfLines = 0;
    
    contentTextLabel.numberOfLines = 0;
    
    [self.contentView addSubview:profileImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:createdTimeLabel];
    [self.contentView addSubview:contentTextLabel];
    [self.contentView addSubview:button];
    [self.contentView addSubview:top_cmt];
    [self.contentView addSubview:hotLabel];
    [self.contentView addSubview:toolBar];
    [toolBar addSubview:lineImageView];
    [toolBar addSubview:dingBtn];
    [toolBar addSubview:caiBtn];
    [toolBar addSubview:shareBtn];
    [toolBar addSubview:cmtBtn];
    NSArray *btnArray = @[dingBtn, caiBtn, shareBtn, cmtBtn];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.insets(padding);
        make.height.width.offset(50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(profileImageView);
        make.left.equalTo(profileImageView.mas_right).insets(padding);
    }];
    
    [createdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(profileImageView);
        make.left.equalTo(nameLabel);
    }];
    
    [contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(profileImageView.mas_bottom).insets(padding);
        make.left.right.insets(padding);
//        make.bottom.equalTo(hotLabel.mas_top).insets(padding);
        _contentLabelBottomConstraint = make.bottom.equalTo(toolBar.mas_top).insets(padding).priorityHigh();
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.insets(padding);
    }];
    
    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.insets(padding);
        make.top.equalTo(contentTextLabel.mas_bottom).insets(padding);
    }];
    
    [top_cmt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(hotLabel.mas_bottom).offset(5);
        make.left.right.insets(padding); 
        _hotLabelBottomConstraint = make.bottom.equalTo(toolBar.mas_top).insets(padding);
    }];
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.offset(0);
        make.height.equalTo(toolBar.mas_width).multipliedBy(0.1);
    }];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(UIEdgeInsetsZero);
        make.height.offset(1);
    }];
    
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
    }];
    
}

/// 设置模型数据
- (void)setModel:(list *)model
{
    _model = model;
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString: model.profile_image] placeholderImage:[UIImage imageNamed:@"setup-head-default"] options:SDWebImageDelayPlaceholder | SDWebImageRetryFailed];
    _nameLabel.text = model.name;
    _createdTimeLabel.text = model.created_at;
    _contentTextLabel.text = model.text;
    
    // 如果有最热评论就赋值
    if (model.top_cmt.count > 0) {
        _top_cmt.text = model.top_cmt[0].content;
        _button.enabled = YES;
    }else{
        _button.enabled = NO;
        _top_cmt.text = nil;
    }
    
    // 判断是否已经展开最热评论
//    NSLog(@"调用了setModel方法");
    if (_model.expanded) {
        [_contentLabelBottomConstraint uninstall];
        [_hotLabelBottomConstraint install];
        _hotLabel.hidden = _top_cmt.hidden = NO;
    } else {
        [_contentLabelBottomConstraint install];
        [_hotLabelBottomConstraint uninstall];
        _hotLabel.hidden = _top_cmt.hidden = YES;
    }
    
    [_caiBtn setTitle:model.cai forState:UIControlStateNormal];
    [_dingBtn setTitle:model.ding forState:UIControlStateNormal];
    [_shareBtn setTitle:model.favourite forState:UIControlStateNormal];
    [_cmtBtn setTitle:model.comment forState:UIControlStateNormal];
    
}

- (UIButton *)creatBtnWithImagge:(NSString *)image title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)]; // 设置偏移量
    
    return button;
    
}

- (void)btnClick
{
//    NSLog(@"点击了最热评论");
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - 重写这个方法能拦截所有设置cell setframe的方法,只要frame发生了改变就会调用
//- (void)setFrame:(CGRect)frame
//{
//    
//    NSLog(@"设置了cell的frame");
//    frame.size.height -= 10;
//    [super setFrame:frame];
//    
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)dealloc
{
    NSLog(@"%s dealloc",__func__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
