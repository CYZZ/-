//
//  YZCollectionCell.m
//  百思不得姐
//
//  Created by cyz on 16/11/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YZCollectionCell.h"
#import "BLJinhuaALLModel.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface YZCollectionCell ()
@property(nonatomic, weak) UILabel *label;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation YZCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UILabel *label = [[UILabel alloc] init];
////        label.backgroundColor = [UIColor orangeColor];
//        label.text = self.titleText;
//        label.numberOfLines = 0;
//        self.label = label;
//        
//        [self.contentView addSubview:label];
//        __weak typeof(self) weakSelf = self;
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.offset(0);
//            make.left.right.offset(0);
//            make.top.greaterThanOrEqualTo(weakSelf.contentView);
//            make.bottom.lessThanOrEqualTo(weakSelf.contentView);
//        }];
        
        [self setupView];
    }
    return self;
}


/**
 初始化View布局
 */
- (void)setupView{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.backgroundColor = [UIColor cyanColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"查看大图" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(seeBigImageButtonCLick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:imageView];
    [self.contentView insertSubview:button aboveSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
//        make.height.equalTo(button.mas_width).multipliedBy(10);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.label.text = titleText;
}

- (void)setModel:(list *)model
{
    _model = model;
//    NSLog(@"model.image_small=%@",model.image_small);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: model.image0] 
                    placeholderImage:[UIImage imageNamed:@"FollowBtnClickBg"]
                             options:SDWebImageContinueInBackground | SDWebImageRetryFailed];
    
}

- (void)seeBigImageButtonCLick
{
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

@end
