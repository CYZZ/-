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
@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@end

@implementation YDCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.playerImageView.tag = 101; // 建议设置在100以上
}

+ (void)registerCellWithTypes:(NSArray<NSString *>*)types onTableView:(UITableView *)tableView
{
	for (NSString *type in types) {
		[tableView registerNib:[UINib nibWithNibName:type bundle:nil] forCellReuseIdentifier:type];
	}
	
//	switch (type) {
//		case YDCellTypeOneImage:
//			[tableView registerNib:[UINib nibWithNibName:@"YDCell" bundle:nil] forCellReuseIdentifier:@"YDCell"];
//			break;
//		case YDCellTypeThreeImage:
//			[tableView registerNib:[UINib nibWithNibName:@"YDThreeImageCell" bundle:nil] forCellReuseIdentifier:@"YDThreeImageCell"];
//			break;
//		case YDCellTypeVideo:
//			[tableView registerNib:[UINib nibWithNibName:@"YDVideoCell" bundle:nil] forCellReuseIdentifier:@"YDVideoCell"];
//			break;
//  default:
//			break;
//	}
}

- (void)setModel:(YDresult *)model
{
	self.playerImageView.tag = 101; 
	_model = model;
	_mainTitleLabel.text = model.title;
	_sourceLabel.text = model.source;
	_commentLabel.text = [NSString stringWithFormat:@"%ld 评", model.comment_count];
	
	if ([model.ctype isEqualToString:@"video_live"]) {
		NSInteger minute = model.duration / 60;
		NSInteger seconds = model.duration %60;
		_videoDurationLabel.text =[NSString stringWithFormat:@"%02ld:%02ld",minute,seconds];
		self.playerImageView = _oneImageView;
	}
	// pushguidetop
	if (model.image_urls.count > 0 && model.image_urls.count < 3) {
		NSString *imageUrl = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[0],model.docid];
		[_oneImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"pushguidetop" ] options:SDWebImageRetryFailed|SDWebImageTransformAnimatedImage];
	}else if (model.image_urls.count >= 3){
		NSString *imageUrl1 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[0],model.docid];
		[_oneImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"pushguidetop"] options:SDWebImageRetryFailed|SDWebImageTransformAnimatedImage];
		
		NSString *imageUrl2 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[1],model.docid];
		[_twoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"pushguidetop"] options:SDWebImageRetryFailed|SDWebImageTransformAnimatedImage];
		
		NSString *imageUrl3 = [NSString stringWithFormat:@"http://i1.go2yd.com/image.php?type=_192x127&url=%@&news_id=%@",model.image_urls[2],model.docid];
		[_threeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl3] placeholderImage:[UIImage imageNamed:@"pushguidetop"] options:SDWebImageRetryFailed|SDWebImageTransformAnimatedImage];
	}
}
///播放视频
- (IBAction)playVideo:(UIButton *)sender {
	if (self.playVideoBlock) {
		self.playVideoBlock();
	}
}
- (IBAction)dislikeBtnClick:(UIButton *)sender {
	
}

/// 通过外部调用公共方法播放视频
- (void)playVideoWithBlock:(void (^)())block
{
	self.playVideoBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
