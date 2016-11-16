//
//  BLEssenceVideoCell.m
//  百思不得姐
//
//  Created by cyz on 16/11/15.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLEssenceVideoCell.h"
#import "BLJinhuaALLModel.h"
#import <UIImageView+WebCache.h>

@interface BLEssenceVideoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation BLEssenceVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mainCellBackground"]];
    // Initialization code
}

- (void)setModel:(list *)model
{
    _model = model;
    
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString: model.profile_image] placeholderImage:[UIImage imageNamed:@"setup-head-default"] options:SDWebImageDelayPlaceholder | SDWebImageRetryFailed];
    
    _nickName.text = model.name;
    
    _creatTime.text = model.created_at;
    
    _contentLabel.text = model.text;
    
    [_dingBtn setTitle:model.ding forState:UIControlStateNormal];
    [_caiBtn setTitle:model.cai forState:UIControlStateNormal];
    [_shareBtn setTitle:model.favourite forState:UIControlStateNormal];
    [_commentBtn setTitle:model.comment forState:UIControlStateNormal];
    
    [_pictureView sd_setImageWithURL:[NSURL URLWithString: model.image_small] 
                       placeholderImage:[UIImage imageNamed:@"FollowBtnClickBg"]
                                options:SDWebImageDelayPlaceholder | SDWebImageRetryFailed];
    
}
- (IBAction)playBtnClick:(UIButton *)sender {
    
    if (self.playBLock) {
        self.playBLock();
    }
    
}
- (IBAction)dingBtnClick:(UIButton *)sender {
}
- (IBAction)caiBtnClick:(UIButton *)sender {
}
- (IBAction)shareBtnClick:(UIButton *)sender {
}
- (IBAction)commentBtnClick:(UIButton *)sender {
    if (self.commentBlock) {
        self.commentBlock();
    }
}

+ (NSString *)cellReuseIDWith:(list *)model
{
    if ([model.type isEqualToString:@"29"]) {
        return @"BLEssenceWordCell";
    }else{
        return @"BLEssenceVideoCell";
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
