//
//  ScrollConflictTestViewControll.m
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/25.
//  Copyright © 2016年 zhsy. All rights reserved.
//
/** (可能)因为模拟器cup处理能力的问题，同一个runloop下同时处理自动轮播和手滑scrollView 造成了轻微的颤抖，真机上效果较好 **/
#import "ScrollConflictTestViewControll.h"


#import "SYImageScrollView.h"
#import "AFNetworking.h"

#import "UIView+SYExtend.h"


#define ImagesRequestUrl1 @"http://mapi.damai.cn/hot201303/nindex.aspx?channel_from=uc_market&source=10101&cityId=852&version=50503"

#define ImagesRequestUrl2 @"http://mapi.damai.cn/hot201303/nindex.aspx?channel_from=uc_market&source=10101&cityId=0&version=50503"

@interface ScrollConflictTestViewControll()<SYImageScrollViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *images;

@property (nonatomic, strong)SYImageScrollView *imageScrollView;


@property (nonatomic, strong)UIScrollView *scrollView;


@end

@implementation ScrollConflictTestViewControll

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _images = [[NSMutableArray alloc] init];

    
    [self creatUI];
    
    [self loadImages];
    
}


- (void)creatUI
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kDWidth, kDHeight - 64)];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.contentSize = CGSizeMake(kDWidth, kDHeight*2);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    _imageScrollView = [[SYImageScrollView alloc] initWithFrame:CGRectMake(0, 200, kDWidth, 200)];
    _imageScrollView.imageLoadMode = SYImsViewImageLoadModeURL;
    _imageScrollView.isAutoScroll = YES;
    _imageScrollView.dataSource = self;
    _imageScrollView.pageShowStyle = SYImsViewPageShowStyleCenter;
    
    
    [_scrollView addSubview:_imageScrollView];
    
    
}

- (void)loadImages
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:ImagesRequestUrl1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [_images removeAllObjects];
        [_images addObjectsFromArray:responseObject];
        [_imageScrollView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片加载失败");
    }];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    /** 设置滑动超出当前显示范围时不自动轮播 **/
    CGRect imageFrame = [self.scrollView convertRect:self.imageScrollView.frame toView:nil];
    CGRect inViewFrame = CGRectMake(0, 64, kDWidth, kDHeight - 64);
    BOOL isInView = CGRectIntersectsRect(imageFrame, inViewFrame);

    _imageScrollView.isAutoScroll = isInView;
    
    NSLog(@"imageScrollView显示：%d",isInView);


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




@end
