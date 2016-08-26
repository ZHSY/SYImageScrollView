//
//  SYImageScrollView.m
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import "SYImageScrollView.h"

#import "UIImageView+WebCache.h"
//#import "UIView+SYExtend.h"

#import "SYTimerManager.h"

#define NewView 1

#define BoundsWidth         self.bounds.size.width//广告的宽度
#define BoundsHeight        self.bounds.size.height//广告的高度
#define Height_TitleLabel   35//图片标题label的高度



//默认配置
#define CurrentPageColor    [UIColor orangeColor]//选中的pageControl颜色
#define PlaceholderImage          [UIImage imageNamed:@"index_Default_pic"]

#define DefaultTimeInterval 3.0 //默认的自动滚动的时间间隔

@interface SYImageScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;


@property (retain,nonatomic) UIView     *titleView;

@property (nonatomic, strong)NSArray    *imageViews;

@property (retain,nonatomic) NSMutableArray * imageArray;
//@property (retain,nonatomic) NSMutableArray * titleArray;


@property (nonatomic, assign)NSInteger  currentAdIndex; //记录中间图片的下标,开始总是为0

@end

@implementation SYImageScrollView

{
    //GCD timer 的名字
    NSString *kTimerName;
    
    //用于不确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;

    
}

#pragma mark - 指定控件所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageArray = [[NSMutableArray alloc] init];
        _iteams = [[NSMutableArray alloc] init];
        _currentAdIndex = 0;
        _timeInterval = DefaultTimeInterval;
        
        /**
         *  因为TimerName 为内部属性不开放
         *  所以为避免多个控件被同时创建而引起timer管理冲突，此处取地址做name
         */
        kTimerName = [NSString stringWithFormat:@"%p",&self];
        
        [self creatContentView];
        
        
        UIView *centerView = self.imageViews[1];
        UITapGestureRecognizer  *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
        [centerView addGestureRecognizer:gesture];

        centerView.userInteractionEnabled = YES;


        
        
    }
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _imageArray = [[NSMutableArray alloc] init];
        _iteams = [[NSMutableArray alloc] init];
        _currentAdIndex = 0;
        _timeInterval = DefaultTimeInterval;
        
        /**
         *  因为TimerName 为内部属性不开放
         *  所以为避免多个控件被同时创建而引起timer管理冲突，此处取地址做name
         */
        kTimerName = [NSString stringWithFormat:@"%p",&self];
        
        [self creatContentView];
        
        UIView *centerView = self.imageViews[1];
        centerView.userInteractionEnabled = YES;
        UIGestureRecognizer *gersture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
        [centerView addGestureRecognizer:gersture];
        
    }
    return self;
}


- (void)creatContentView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
 
    _scrollView.bounces = NO;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(BoundsWidth, 0);
    _scrollView.contentSize = CGSizeMake(BoundsWidth * 3, BoundsHeight);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    
    
    _imageViews = ({
        
        NSMutableArray *imageViewArray = [[NSMutableArray alloc] init];
        
        CGFloat itemWidth = BoundsWidth;
        CGFloat itemHeight = BoundsHeight;
        
        for (int i =0 ; i<3; i++) {
            
            UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth *i, 0, itemWidth, itemHeight)];
            [imageViewArray addObject:item];
            
        }
        
        imageViewArray;
    });
    
    for (UIView *imageView in _imageViews) {
        [_scrollView addSubview:imageView];
    }
    


}


#pragma mark - 设置显示的方式
//标题语显示方式
-(void)setTitleStyle:(SYImsViewTitleShowStyle)titleStyle
{
    
    if (_titleStyle == titleStyle) {
        return;
    }
    
    _titleStyle = titleStyle;
    
    if (titleStyle == SYImsViewTitleShowStyleNone) {
        [self hideTitleView];
    }else{
        
        [self showTitleView];
        CGRect frame = _titleView.frame;
        
        if (titleStyle == SYImsViewTitleShowStyleTop){
            frame.origin.y = 0;
        }else{
            frame.origin.y = BoundsHeight - frame.size.height;
        }
        _titleView.frame = frame;
        
        if (self.iteams.count > 0) {
            SYImageScrollIteam *iteam = self.iteams[_currentAdIndex];
            _titleLabel.text = iteam.ImageTitle?iteam.ImageTitle:@"";
        }
        
    }
    
    
}

//pageControl 的显示方式
- (void)setPageShowStyle:(SYImsViewPageShowStyle)pageShowStyle
{
    if (_pageShowStyle == pageShowStyle) {
        return;
    }
    
    _pageShowStyle = pageShowStyle;
    
    [self refreshPageControl];
    
}

// 是否自动滚动广告
- (void)setIsAutoScroll:(BOOL)isAutoScroll
{
    if(isAutoScroll == _isAutoScroll){
        return;
    }
    _isAutoScroll = isAutoScroll;
    
    if (isAutoScroll) {
        [self startAutoScroll];
    }else{
        [self stopAutoScroll];
    }
}



#pragma mark - 刷新数据
- (void)reloadData
{
    
    if (self.dataSource) {
        
        [self stopAutoScroll];
        
        /** 获取图片元素 **/
        NSArray *iteams = [self.dataSource syImsViewIteams:self];

        if (iteams.count<2) {
            /** SYImageScrollView 不支持少于2张图片的设置 如有需要可在此处自行兼容 **/
            NSLog(@"SYImageScrollView: 不支持少于2张图片的设置");
            return;
        }
        [self.iteams removeAllObjects];
        [self.iteams addObjectsFromArray:iteams];
        
        [self.imageArray removeAllObjects];
        
        for (SYImageScrollIteam *iteam in _iteams) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = self.bounds;
            
            if (_imageLoadMode == SYImsViewImageLoadModeDefault || _imageLoadMode == SYImsViewImageLoadModeURL) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:iteam.ImageUrl] placeholderImage:PlaceholderImage];
            }else if(_imageLoadMode == SYImsViewImageLoadModeImage){
                imageView.image = iteam.Image;
            }else{
                imageView.image = [UIImage imageNamed:iteam.ImageName];
            }
            
            [self.imageArray addObject:imageView];
        }
       
        
        /** 图片标题 **/
       
        //预设广告语
        if (self.titleStyle != SYImsViewTitleShowStyleNone) {
            SYImageScrollIteam *iteam = _iteams[0];
            _titleLabel.text = iteam.ImageTitle?iteam.ImageTitle:@"";
        }
            
        
        
        /** 预设图片 **/
       for (int i =0 ; i < _imageViews.count; i++) {
        
           UIImageView *oldImageView = _imageViews[i];
           UIImageView *newImageView =  (i>0)?_imageArray[i-1]:[_imageArray lastObject];
        
           [self replaceImageView:oldImageView withImageView:newImageView];
        }

        
        /** 设置pageControl **/
        _currentAdIndex = 0;
        [self refreshPageControl];
        
        if(_isAutoScroll){
            [self startAutoScroll];
        }
        
    }
    
}



#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    if (self.imageArray.count< 2) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(BoundsWidth * 2, 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

//手动控制图片滚动 停止自动滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self refreshImageView];
    
}
/**
 //监测scrollview 的 ContentOffset 会比等待 减速减速更好 如果两次滑动链接过快 减速结束只会触发一次 
 这样就滑不动了
 **/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double  doubleX  = scrollView.contentOffset.x/BoundsWidth;
    int     intX     = scrollView.contentOffset.x/BoundsWidth;
    if (doubleX == intX) {
        [self refreshImageView];
    }
    
}

#pragma mark - 点击事件

- (void)imageSelected:(UIGestureRecognizer *)gerstur
{
    if([self.dataSource  respondsToSelector:@selector(syImsView:selectedAdIndex:)]){
        
        [self.dataSource syImsView:self selectedAdIndex:self.currentAdIndex];
    }else{
        
        NSLog(@"SYImageScrollView: 点击事件未设置");
    }
    
}



#pragma mark - pravite


- (void)replaceImageView:(UIImageView *)imageView withImageView:(UIImageView *)replaceView
{
    
    UIView *view = [imageView viewWithTag:11];
    if (view) {
        [view removeFromSuperview];
    }
    [replaceView removeFromSuperview];
    replaceView.tag = 11;
    [imageView addSubview:replaceView];
//    [imageView sendSubviewToBack:replaceView];
}

- (void)refreshPageControl
{
    if (_pageShowStyle == SYImsViewPageShowStyleNone) {
        [self hidePageControl];
        return;
    }
    
    [self showPageControl];
    
    _pageControl.currentPage = _currentAdIndex;
    _pageControl.numberOfPages = _imageArray.count;
    
    CGRect controlFrame = _pageControl.frame;
    
    controlFrame.size.width = _pageControl.numberOfPages*20;
    
    if (_pageShowStyle == SYImsViewPageShowStyleLeft) {
        controlFrame.origin.x = 0;
    }else if (_pageShowStyle == SYImsViewPageShowStyleCenter) {
        controlFrame.origin.x = (BoundsWidth - controlFrame.size.width)/2;
    }else{
        controlFrame.origin.x = BoundsWidth - controlFrame.size.width;
    }

    _pageControl.frame = controlFrame;
    
}

- (void)refreshImageView
{
    if (!_imageArray.count>0) {
        return;
    }
    
    //无效的滚动范围 则不刷新图片
    if (self.scrollView.contentOffset.x == BoundsWidth) {
        
        //判断是非恢复自动滚动
        if (!_isTimeUp && _isAutoScroll) {
            [self startAutoScroll];
        }
        
        return;
    }
    
    if (self.scrollView.contentOffset.x == 0)
    {
        if (_currentAdIndex == 0) {
            _currentAdIndex =_imageArray.count;
        }
        _currentAdIndex = (_currentAdIndex-1)%_imageArray.count;
       
    }
    else if(self.scrollView.contentOffset.x == BoundsWidth * 2)
    {
        _currentAdIndex = (_currentAdIndex+1)%_imageArray.count;

    }
    else
    {
        return;
    }
    
    if (_pageShowStyle != SYImsViewPageShowStyleNone) {
            _pageControl.currentPage = _currentAdIndex;
    }
    
    if (self.titleStyle != SYImsViewTitleShowStyleNone) {
        SYImageScrollIteam *iteam = self.iteams[_currentAdIndex];
        _titleLabel.text = iteam.ImageTitle?iteam.ImageTitle:@"";
    }
    
    
    NSInteger index = _currentAdIndex - 1;
    for (UIImageView *imageView in self.imageViews) {
        
        NSInteger cur = (index<0)?_imageArray.count -1:index%_imageArray.count;
        [self replaceImageView:imageView withImageView:_imageArray[cur]];
        index++;
    }
    
    self.scrollView.contentOffset = CGPointMake(BoundsWidth, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp && _isAutoScroll) {
        [self startAutoScroll];
    }
    
    
}



- (void)hideTitleView
{
    if (!_titleView) {
        return;
    }
    _titleView.hidden = YES;
}

- (void)showTitleView
{
    
    if (!_titleView) {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BoundsWidth, Height_TitleLabel)];
        _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BoundsWidth - 20, Height_TitleLabel)];
        _titleLabel.textColor = [UIColor whiteColor];
        
        
        [_titleView addSubview:_titleLabel];
        
        [self insertSubview:_titleView belowSubview:_pageControl];
        
    }
    
    _titleView.hidden = NO;
    
}


- (void)hidePageControl
{
    if (!_pageControl) {
        return;
    }
    _pageControl.hidden = YES;

}

- (void)showPageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, BoundsHeight - 20, BoundsWidth, 20)];
        _pageControl.currentPageIndicatorTintColor = CurrentPageColor;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        
        _pageControl.currentPage = 0;
        _pageControl.enabled = NO;
        [self addSubview:_pageControl];
    }
    
    _pageControl.hidden = NO;
    
}

- (void)startAutoScroll
{
    __weak typeof(self) weakSelf = self;
    [[SYTimerManager sharedManager] scheduledDispatchTimerWithName:kTimerName timeInterval:_timeInterval queue:nil repeats:YES action:^{
        [weakSelf animalMoveImage];
    }];
  
    _isTimeUp = YES;
}

- (void)stopAutoScroll
{
    
    [[SYTimerManager sharedManager] cancelTimerWithName:kTimerName];
    _isTimeUp = NO;
    
}

- (void)dealloc
{
    [self stopAutoScroll];
    NSLog(@"SYImageScrollView: 释放");
}


@end
