//
//  BLDoubanCell.m
//  百思不得姐
//
//  Created by cyz on 16/12/16.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLDoubanCell.h"
#import "BLBook.h"
#import <UIImageView+WebCache.h>

@interface BLDoubanCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookDiscriptionLabel;

@end

@implementation BLDoubanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BLBook *)model
{
	_model = model;
	[self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.small] placeholderImage:[UIImage imageNamed:@"pushguidetop"] options:SDWebImageRetryFailed|SDWebImageDelayPlaceholder ];
	self.bookTitleLabel.text = model.title;
	self.bookDiscriptionLabel.text = model.subtitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
