//
//  BLVTGPageController.m
//  百思不得姐
//
//  Created by cyz on 16/12/13.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLVTGPageController.h"
#import "BLAllTableVC.h"
//#import <MenuInfo.h>

@interface BLVTGPageController ()
/// 标题数组
@property(nonatomic, strong) NSMutableArray<NSString *> *titleArray;

@end

@implementation BLVTGPageController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
//	self.magicView.dataSource = self;
//	self.magicView.delegate = self;
//	self.magicView.layoutStyle = VTLayoutStyleDefault;
//	self.magicView.switchStyle = VTLayoutStyleDefault;
//	self.magicView.navigationHeight = 40.f;
	self.magicView.navigationHeight = 44;
	self.magicView.headerHeight = 64;
	self.edgesForExtendedLayout = UIRectEdgeAll;
	[self.magicView reloadData];
	[self setupUI];
}

- (void)setupUI
{
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[rightButton setTitle:@"添加频道" forState:UIControlStateNormal];
	[rightButton sizeToFit];
	[rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *Item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = Item;
}

- (void)rightButtonClick{
	[_titleArray addObject:@"新增的标题"];
	[self.magicView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSLog(@"%s",__func__);
//	[self.magicView reloadData];
}
- (NSMutableArray<NSString *> *)titleArray
{
	if (!_titleArray) {
		_titleArray = [NSMutableArray array];
		for (int i = 0; i < 3; i++) {
			[_titleArray addObject:[NSString stringWithFormat: @"标题%d",i]];
		}
	}
	return _titleArray;
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
	return self.titleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
	static NSString *itemIdentifier = @"itemIdentifier";
	UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
	if (!menuItem) {
		menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
		[menuItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[menuItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
		menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
	}
	return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
	BLAllTableVC *tableVC = nil;
	if (pageIndex == 0) {
		tableVC = [magicView dequeueReusablePageWithIdentifier:@"29"];
		if (!tableVC) {
			tableVC = [[BLAllTableVC alloc] init];
			tableVC.typeID = @"29";
			tableVC.reuseIdentifier = @"29";
		}
	}else if (pageIndex == 1){
		tableVC = [magicView dequeueReusablePageWithIdentifier:@"41"];
		if (!tableVC) {
			tableVC = [[BLAllTableVC alloc] init];
			tableVC.typeID = @"41";
			tableVC.reuseIdentifier = @"41";
		}
	}else{
		tableVC = [magicView dequeueReusablePageWithIdentifier:@"1"];
		if (!tableVC) {
			tableVC = [[BLAllTableVC alloc] init];
			tableVC.typeID = @"1";
			tableVC.reuseIdentifier = @"1";
		}
	}
	
	
	return tableVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
