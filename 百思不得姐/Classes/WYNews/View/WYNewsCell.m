//
//  WYNewsCell.m
//  百思不得姐
//
//  Created by cyz on 16/11/19.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYNewsCell.h"
#import "listModel.h"
#import <UIImageView+WebCache.h>

@interface WYNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@end

@implementation WYNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(listModel *)model
{
    _model = model;
    [_firstImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _titleLabel.text = model.ltitle;
    
    _sortLabel.text = model.source;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightBtnClick:(id)sender {
	
	if (self.rightBtnBlock) {
		self.rightBtnBlock();
	}
	
}

@end
