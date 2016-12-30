//
//  YDTagView.m
//  百思不得姐
//
//  Created by cyz on 16/12/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDTagView.h"
#import "YDItem.h"
CGFloat const imageViewWH = 20;
@interface YDTagView ()<UIGestureRecognizerDelegate>
{
	/// 由于设置了只读属性就只能在这里成重新设置下划线的值
	NSMutableArray *_tagArray;
}
@property (nonatomic, strong) NSMutableDictionary *tags;
@property (nonatomic, strong) NSMutableArray *tagButtons;

/// 需要移动的矩阵
@property (nonatomic, assign) CGRect moveFinalRect;
/// 即将被替换的按钮中心坐标
@property (nonatomic, assign) CGPoint oriCenter;
/// 拖拽频道的起始位置
@property (nonatomic, assign) NSInteger beginIndex;
/// 拖拽频道结束的位置
@property (nonatomic, assign) NSInteger endedIndex;

@end

@implementation YDTagView

#pragma mark - lazyLoad 懒加载初始化get方法
/// 这是个只读属性
- (NSMutableArray *)tagArrays
{
	if (_tagArray == nil) {
		_tagArray = [NSMutableArray array];
	}
	return _tagArray;
}

- (NSMutableArray *)tagButtons
{
	if (_tagButtons == nil) {
		_tagButtons = [NSMutableArray array];
	}
	return _tagButtons;
}

- (NSMutableDictionary *)tags
{
	if (_tags == nil) {
		_tags = [NSMutableDictionary dictionary];
	}
	return _tags;
}

- (CGFloat)contentHeight
{
	if (self.tagButtons.count <= 0) {
		return 0;
	}else{
		return CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
	}
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}
#pragma mark - 初始化配置
/// 初始化配置
- (void)setup
{
	_tagMargin = 10;
	_tagColor = [UIColor redColor];
	_tagMargin = 5;
	_tagCornerRadius = 5;
	_tagBorderWidth = 0;
	_tagBorderColor = _tagColor;
	_tagListCols = 4;
	_scaleTagInSort = 1;
	_isFitTagViewH = YES;
	_tagFont = [UIFont systemFontOfSize:13];
	self.clipsToBounds = YES;
}
- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)setScaleTagInSort:(CGFloat)scaleTagInSort
{
	if (scaleTagInSort < 1) {
		@throw [NSException exceptionWithName:@"YDError" reason:@"(scaleTagInSort)的值必须大于1" userInfo:nil];
	}
	_scaleTagInSort = scaleTagInSort;
}

#warning change 修改了
#pragma mark - 重置所有的标签
- (void)setTagArrays:(NSMutableArray *)tagArrays
{
	// 注意，key的值是唯一的如果频道有相同的key就只会删除其中一个
	NSArray *titles = _tagArray.copy;
	for (NSString *str in titles) {
		NSLog(@"删除的title=%@",str);
		[self deleteTag:str];
	}
	[self addTags:tagArrays];
}

#pragma mark - Public 公共方法
// 添加标签数组
- (void)addTags:(NSArray<NSString *> *)tagStrs
{
	if (self.frame.size.width == 0) {
		@throw [NSException exceptionWithName:@"YDError" reason:@"先设置内容视图的frame才能添加标签" userInfo:nil
				];
	}
	
	for (NSString *tagStr in tagStrs) {
		[self addTag:tagStr];
	}
}
// 添加一个标签到最后
- (void)addTag:(NSString *)tagStr
{
	YDItem *tagButton = [self creatTag:tagStr];
	// 保存到数组
	[self.tagButtons addObject:tagButton];
	
	// 保存到字典
	[self.tags setObject:tagButton forKey:tagStr];
	[self.tagArrays addObject:tagStr];
	
	// 设置按钮的位置
	[self setTagButtonFrame:tagButton.tag extreMargin:YES];
	
	// 更新自己的高度
	if (_isFitTagViewH) {
		CGRect frame = self.frame;
		frame.size.height = self.contentHeight;
		[UIView animateWithDuration:0.25 animations:^{
			self.frame = frame;
		}];
	}
}

// 插入到指定位置
- (void)insetTag:(NSString *)tagStr At:(NSInteger)index
{
	YDItem *tagButton = [self creatTag:tagStr];
	
	[self.tagButtons insertObject:tagButton atIndex:index];
	
	[self.tagArrays insertObject:tagButton.currentTitle atIndex:index];
	
	// 设置按钮的位置
	[self setTagButtonFrame:tagButton.tag extreMargin:YES];
	
	// 更新tag值
	[self updateAllTag];
	
	// 更新之后标签frame
	[self setTagButtonFrame:index extreMargin:NO];
	[UIView animateWithDuration:0.25 animations:^{
		[self updateLaterButtonFrom:index + 1];
	} completion:^(BOOL finished) {
//		CGRect frame = self.frame;
//		frame.size.height = self.contentHeight;
//		self.frame = frame;
	}];
	
	// 更新自己的高度
	if (_isFitTagViewH) {
		CGRect frame = self.frame;
		frame.size.height = self.contentHeight;
		[UIView animateWithDuration:0.25 animations:^{
			self.frame = frame;
		}];
	}
}

/// 创建tag按钮
- (YDItem *)creatTag:(NSString *)tagStr
{
	// 如果自定义就使用自定义的控件
	YDItem *tagButton = _item? _item : [YDItem buttonWithType:UIButtonTypeCustom];
	if (_item == nil) {
		tagButton.margin = _tagMargin;
	}
	
	tagButton.layer.cornerRadius = _tagCornerRadius;
	tagButton.layer.borderWidth = _tagBorderWidth;
	tagButton.layer.borderColor = _tagBorderColor.CGColor;
	//	tagButton.clipsToBounds = YES; // 会裁剪超出的部分
	tagButton.tag = self.tagButtons.count;
	[tagButton setImage:_tagDeleteImage forState:UIControlStateNormal];
	[tagButton setTitle:tagStr forState:UIControlStateNormal];
	[tagButton setTitleColor:_tagColor forState:UIControlStateNormal];
	[tagButton setBackgroundColor:_tagBackgroundColor];
	[tagButton setBackgroundImage:_tagBackgroundImage forState:UIControlStateNormal];
	tagButton.titleLabel.font = _tagFont;
	[tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
	// 如果允许排序就添加手势
	if (_isSort) {
		// 添加拖拽手势
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
		[tagButton addGestureRecognizer:pan];
		//FIXME: 新新增了代理方法
		pan.delegate = self;

	}
	
	[self addSubview:tagButton];
	
	// 保存到字典
	[self.tags setObject:tagButton forKey:tagStr];
	
	return tagButton;
}


/// 点击标签
- (void)clickTag:(YDItem *)button
{
	if (self.clickTagBlock) {
		self.clickTagBlock(button.currentTitle);
	}
}

- (void)deleteTag:(NSString *)tagStr
{
	// 获取对饮的标题按钮
	YDItem *button = self.tags[tagStr];
	
	// 移除按钮
	[button removeFromSuperview];
	
	// 从数组中移除
	[self.tagButtons removeObject:button];
	
	// 从字典中移除
	[self.tags removeObjectForKey:tagStr];
	
	// 移除标题数组
	[self.tagArrays removeObject:tagStr];
	
	// 更新tag
	[self updateAllTag];
	
	// 更新后面的按钮frame
	[UIView animateWithDuration:0.25 animations:^{
		[self updateLaterButtonFrom:button.tag];
	}];
	
	// 更新当前view的frame
	if (_isFitTagViewH) {
		CGRect frame = self.frame;
		frame.size.height = self.contentHeight;
		[UIView animateWithDuration:0.25 animations:^{
			self.frame = frame;
		}];
	}
}

/// 拖拽手势触发
- (void)pan:(UIPanGestureRecognizer *)gesture
{
	// 获取偏移量
	CGPoint transP = [gesture translationInView:self];
	YDItem *tagButton = (YDItem *)gesture.view;
	if (tagButton.tag <= self.ignoreSortCount) {
		NSLog(@"开始的tag=%ld",tagButton.tag);
		return;
	}
	// 开始接触
	if (gesture.state == UIGestureRecognizerStateBegan) {
		// 如果被点击的标签是属于被忽略的就返回
		self.beginIndex = tagButton.tag; // 在手势开始的时候记录被拖拽的item位置
		_oriCenter = tagButton.center;
		[UIView animateWithDuration:0.25 animations:^{
			tagButton.transform = CGAffineTransformMakeScale(_scaleTagInSort, _scaleTagInSort);
		}];
		[self addSubview:tagButton];
		
	}
	
	CGPoint center = tagButton.center;
	center.x += transP.x;
	center.y += transP.y;
	tagButton.center = center;
	
	// 正在拖拽，会持续调用...
	if (gesture.state == UIGestureRecognizerStateChanged) {
		
		// 获取当前按钮中心点在哪个按钮上（otherButton就是即将被挤开的按钮）
		YDItem *otherButton = [self itemCenterInButton:tagButton];
		
		// 如果按钮的tag被忽略就不允许移动
		if (otherButton.tag <= self.ignoreSortCount) {
			//FIXME: 这个地方不能用return因为方法的末尾需要进行手势的添加
//			return;
//			NSLog(@"被忽略的button=%@,tag=%ld",otherButton,otherButton.tag);
		}else if (otherButton) { // 掺入到当前按钮的位置
//			NSLog(@"没有忽略tag=%ld",otherButton.tag);
			// 获取需要插入的tag值
			NSInteger i = otherButton.tag;
			// 获取当前tag
			NSInteger curI = tagButton.tag;
			_moveFinalRect = otherButton.frame;
			
			// 排序
			// 移除之前的按钮
			[self.tagButtons removeObject:tagButton];
			[self.tagButtons insertObject:tagButton atIndex:i];
			
			[self.tagArrays removeObject:tagButton.currentTitle];
			[self.tagArrays insertObject:tagButton.currentTitle atIndex:i];
			
			// 更新tag
			[self updateAllTag];
			
			if (curI > i) { // 后面添加到前面
				// 更新之后标签frame
				[UIView animateWithDuration:0.25 animations:^{
					[self updateLaterButtonFrom:i +1];
				}];
			}else{
				// 前面的按钮往后移动
				[UIView animateWithDuration:0.25 animations:^{
					[self updateBeforeTagButtonFrom:i];
				}];
				
			}
		}
	}
	
	// 手势结束
	if (gesture.state == UIGestureRecognizerStateEnded) {
		[UIView animateWithDuration:0.25 animations:^{
			tagButton.transform = CGAffineTransformIdentity;
			if (_moveFinalRect.size.width <= 0) {
				tagButton.center = _oriCenter;
			} else {
				tagButton.frame = _moveFinalRect;
			}
		} completion:^(BOOL finished) {
			_moveFinalRect = CGRectZero;
		}];
		self.endedIndex = tagButton.tag; // 手势结束的时候记录替换按钮的索引
		if (self.exchangeItemsBlock) {
			self.exchangeItemsBlock(self.beginIndex, self.endedIndex);
		}
		
	}
	
	[gesture setTranslation:CGPointZero inView:self];
}

#pragma mark - 交换连个索引
- (void)exchangeItemsBetween:(void (^)(NSInteger, NSInteger))change
{
	self.exchangeItemsBlock = change;
//	if (change) {
//		change(self.beginIndex, self.endedIndex);
//	}
}



/**
 设置标签的frame

 @param index 索引
 @param extreMargin 是否有设置大小
 */
- (void)setTagButtonFrame:(NSInteger)index extreMargin:(BOOL)extreMargin
{
	// 获取上一个按钮的tag
	NSInteger preIndex = index - 1;
	// 定义一个按钮
	YDItem *preButton;
	// 如果不是第一个标签的情况
	if (preIndex >=0) {
		preButton = self.tagButtons[preIndex];
	}
	
	// 获取当前按钮
	YDItem *tagButton = self.tagButtons[index];
	// 判断是否设置标签的尺寸
	if (_tagSize.width == 0) { // 如果没有设置标签的尺寸
		// 自适应标签尺寸
		// 设置标签按钮frame（自适应）
		[self setTagButtonCustomFrame:tagButton preButton:preButton extreMargin:extreMargin];
	}else{ // 按规律排布
		// 计算标签按钮frame
		[self setTagButtonRegularFrame:tagButton];
	}
}

/**
 流式布局

 @param tagButton 需要布局的按钮
 */
- (void)setTagButtonRegularFrame:(YDItem *)tagButton
{
	// 获取角标
	NSInteger i = tagButton.tag;
	NSInteger col = i % _tagListCols; // 第几列
	NSInteger row = i / _tagListCols; // 在第几行
	CGFloat btnW = _tagSize.width;
	CGFloat btnH = _tagSize.height;
	// 间距的数量是列数-1
	NSInteger margin = (self.bounds.size.width - _tagListCols * btnW - 2 * _tagMargin) / (_tagListCols - 1);
	CGFloat btnX = _tagMargin + col * (btnW + margin);
	CGFloat btnY = _tagMargin + row * (btnH + margin);
	
	tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

- (YDItem *)itemCenterInButton:(YDItem *)curButton
{
	for (YDItem *button in self.tagButtons) {
		if (curButton == button) {
			continue;
		}
		if (CGRectContainsPoint(button.frame, curButton.center)) {
			return button;
		}
	}
	return nil;
}
/// 更新所有标签
- (void)updateAllTag
{
	NSInteger count = self.tagButtons.count;
	for (int i = 0; i < count; i++) {
		YDItem *tagButton = self.tagButtons[i];
		tagButton.tag = i;
	}
}

- (void)updateBeforeTagButtonFrom:(NSInteger)index
{
	for (int i = 0; i < index; i++) {
		// 更新按钮frame
		[self setTagButtonFrame:i extreMargin:NO];
	}
}

- (void)updateLaterButtonFrom:(NSInteger)index
{
	NSInteger count = self.tagButtons.count;
	
	for (NSInteger i = index; i < count; i++) {
		// 更新按钮
		[self setTagButtonFrame:i extreMargin:NO];
	}
}


/**
 计算标签的frame

 @param tagButton 当前需要计算的item
 @param preButton 前一个item
 @param extremargin 是否大小自适应
 */
- (void)setTagButtonCustomFrame:(YDItem *)tagButton preButton:(YDItem *)preButton extreMargin:(BOOL)extremargin
{
	// 上一个按钮的最大X值 + 间距
	CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
	
	// 左边按钮的Y值，如果没有就是标签的间距
	CGFloat btnY = preButton? preButton.frame.origin.y : _tagMargin;
	
	// 获取按钮的宽度（使用文字大小计算)
	
	NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
	normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
	
	CGSize btnMaxRect = CGSizeMake(self.frame.size.width, _tagFont.pointSize);
	CGSize buttonSize = [tagButton.currentTitle boundingRectWithSize:btnMaxRect options:NSStringDrawingUsesLineFragmentOrigin attributes:normalAttrs context:nil].size;
	CGFloat titleW = buttonSize.width;
	CGFloat titleH = buttonSize.height;
	// 按钮的宽度是文字宽度加上间距
	CGFloat btnW = extremargin? titleW + 2 * _tagMargin : tagButton.bounds.size.width;
	if (_tagDeleteImage &&extremargin == YES) {
		btnW += (imageViewWH + _tagMargin);
	}
	// 获取按钮高度
	CGFloat btnH = extremargin? titleH + 2 * _tagMargin : tagButton.bounds.size.height;
	if (_tagDeleteImage && extremargin == YES) {
		CGFloat height = imageViewWH > titleH ? imageViewWH : titleH;
		btnH = height + 2 * _tagMargin;
	}
	
	// 判断当前按钮是否超出屏幕外
	CGFloat rightWidth = self.bounds.size.width - btnX;
	
	if (rightWidth < btnW) {
		// 超出屏幕外就换行
		btnX = _tagMargin;
		btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
	}
	
	tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark - <UIGestureRecognizerDelegate>



@end





