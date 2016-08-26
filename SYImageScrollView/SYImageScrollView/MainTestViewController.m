//
//  MainTestViewController.m
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import "MainTestViewController.h"

#import "SYImageScrollView.h"
#import "AFNetworking.h"

#import "UIView+SYExtend.h"


#define ImagesRequestUrl1 @"http://mapi.damai.cn/hot201303/nindex.aspx?channel_from=uc_market&source=10101&cityId=852&version=50503"

#define ImagesRequestUrl2 @"http://mapi.damai.cn/hot201303/nindex.aspx?channel_from=uc_market&source=10101&cityId=0&version=50503"

@interface MainTestViewController()<SYImageScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *images;

@property (nonatomic, strong)SYImageScrollView *imageScrollView;



@end

@implementation MainTestViewController
{
    NSArray *_imageUrls;
    NSInteger _currentUrlIndex;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _images = [[NSMutableArray alloc] init];
    _imageUrls = @[ImagesRequestUrl1,ImagesRequestUrl2];
    _currentUrlIndex = 0;
    
    [self creatUI];
    
    [self loadImages];
    
}

- (void)creatUI
{
    _imageScrollView = [[SYImageScrollView alloc] initWithFrame:CGRectMake(0, 64, kDWidth, 200)];
    _imageScrollView.imageLoadMode = SYImsViewImageLoadModeURL;
    _imageScrollView.isAutoScroll = YES;
    _imageScrollView.dataSource = self;
    _imageScrollView.pageShowStyle = SYImsViewPageShowStyleCenter;

    
    [self.view addSubview:_imageScrollView];
    

    /** 测试功能 **/
    
    CGFloat space = 25;
    CGFloat left = space;
    CGFloat top = _imageScrollView.bottom + space;
    /** 自动滚动 **/
    UIButton *scrollBtn = [self getTestBtnWithTitle:@"自动滚动"];
    scrollBtn.origin = CGPointMake(left, top);
    [scrollBtn addTarget:self action:@selector(changeIsAutoScroll) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:scrollBtn];

    top += (scrollBtn.height + space);
    
    /** 标题显示 **/
    UIButton *titleBtn = [self getTestBtnWithTitle:@"标题显示"];
    titleBtn.origin = CGPointMake(left, top);
    [titleBtn addTarget:self action:@selector(changeTitleShowStyle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleBtn];
    
    
    top += (titleBtn.height + space);
    
    /** 页码小点的位置 **/
    UIButton *pageStyleBtn = [self getTestBtnWithTitle:@"小点显示"];
    pageStyleBtn.origin = CGPointMake(left, top);
    [pageStyleBtn addTarget:self action:@selector(changePageShowStyle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pageStyleBtn];
    
    
    top += (pageStyleBtn.height + space);
    
    /** 刷新图片 **/
    UIButton *refreshBtn = [self getTestBtnWithTitle:@"刷新图片"];
    refreshBtn.origin = CGPointMake(left, top);
    [refreshBtn addTarget:self action:@selector(refreshImages) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:refreshBtn];
    
}

- (void)loadImages
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:[_imageUrls objectAtIndex:_currentUrlIndex] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [_images removeAllObjects];
        [_images addObjectsFromArray:responseObject];
        [_imageScrollView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片加载失败");
    }];
    
    
}

#pragma mark - SYImageScrollViewDelegate

- (NSArray<SYImageScrollIteam *> *)syImsViewIteams:(SYImageScrollView *)imageScrollView
{
    NSMutableArray *iteams = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _images) {
        SYImageScrollIteam *iteam = [[SYImageScrollIteam alloc] init];
        iteam.ImageUrl = dic[@"Pic"];
        iteam.ImageTitle = [NSString stringWithFormat:@"图片 Id：%@",dic[@"ProjectID"]];
        [iteams addObject:iteam];
    }
    return iteams;
    
    
}


- (void)syImsView:(SYImageScrollView *)imageScrollView selectedAdIndex:(NSInteger)index
{
    NSLog(@"点击图片index：%ld",(long)index);
}



#pragma mark - testAction


- (void)changeIsAutoScroll
{
    _imageScrollView.isAutoScroll = !_imageScrollView.isAutoScroll;
}

- (void)changeTitleShowStyle
{
    SYImsViewTitleShowStyle style = self.imageScrollView.titleStyle;
    
    self.imageScrollView.titleStyle = (style +1)%3;
    
}

- (void)changePageShowStyle
{
    SYImsViewPageShowStyle style = self.imageScrollView.pageShowStyle;
    self.imageScrollView.pageShowStyle = (style +1)%4;
}

- (void)refreshImages
{
    _currentUrlIndex = (_currentUrlIndex +1)%_imageUrls.count;
    [self loadImages];
}



#pragma mark - pravite

- (UIButton *)getTestBtnWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    return btn;
    
}




@end
