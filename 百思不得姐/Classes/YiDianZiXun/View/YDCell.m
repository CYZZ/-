//
//  YDCell.m
//  百思不得姐
//
//  Created by cyz on 16/12/14.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDCell.h"
#import "YDresult.h"
#import <UIImageView+WebCache.h>

@interface YDCell ()
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;

@end

@implementation YDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YDresult *)model
{
	_model = model;
	_mainTitleLabel.text = model.title;
	// pushguidetop
	if (model.image_urls.count > 0 && model.image_urls.count < 3) {
		NSString *imageUrl = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[0],model.docid];
		[_oneImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pushguidetop"]];
	}else if (model.image_urls.count >= 3){
		NSString *imageUrl1 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[0],model.docid];
		[_oneImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"pushguidetop"]];
		
		NSString *imageUrl2 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[1],model.docid];
		[_twoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"pushguidetop"]];
		
		NSString *imageUrl3 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[2],model.docid];
		[_threeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl3] placeholderImage:[UIImage imageNamed:@"pushguidetop"]];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
