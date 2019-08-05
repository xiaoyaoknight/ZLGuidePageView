//
//  ZLGuidePageView.m
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/2.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "ZLGuidePageView.h"
#import "ZLGifImageOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "AppMacro.h"

@interface ZLGuidePageView ()<UIScrollViewDelegate>
/**
 引导scrollview
 */
@property (nonatomic, strong) UIScrollView *guidePageView;

/**
 图片数组
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 记录滑动number
 */
@property (nonatomic, assign) NSInteger slideIntoNumber;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) MPMoviePlayerController *playerController;
#pragma clang diagnostic pop

@end

@implementation ZLGuidePageView

#pragma mark –-------------------------- Life cycle（生命周期）–--------------------------
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray hideStartButton:(BOOL)hideStartButton {
    if ([super initWithFrame:frame]) {
        self.slideInto = NO;
        self.imageArray = imageNameArray;
        
        // 设置引导视图的scrollview
        self.guidePageView.frame = frame;
        self.guidePageView.contentSize = CGSizeMake(SCREEN_WIDTH * imageNameArray.count, SCREEN_HEIGHT);
        
        // 设置引导页上的跳过按钮
        [self addSubview:self.skipButton];
        
        // 添加引导图片
        for (int i = 0; i < imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.userInteractionEnabled = YES;
            
            NSString *path = [[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSString *imageString = [ZLGifImageOperation contentTypeForImageData:data];
            
            if ([imageString isEqualToString:@"gif"]) {
                imageView = (UIImageView *)[[ZLGifImageOperation alloc] initWithFrame:imageView.frame gifImageData:data];
                [self.guidePageView addSubview:imageView];
            } else {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
                [self.guidePageView addSubview:imageView];
            }
            
            // 最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count - 1 && hideStartButton == NO) {
                [imageView addSubview:self.startButton];
            }
        }
        // 设置引导页上的页面控制器
        [self addSubview:self.imagePageControl];
        
    }
    return self;
}

/**
 *  快捷创建引导页(视频引导页)
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return         instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
#pragma clang diagnostic pop
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 30 - 40, SCREEN_WIDTH - 40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        [self.playerController.view addSubview:movieStartButton];
        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}

#pragma mark –-------------------------- Setter/Getter –--------------------------

/**
 引导scrollview
 */
- (UIScrollView *)guidePageView {
    if (_guidePageView == nil) {
        
        _guidePageView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _guidePageView.backgroundColor = [UIColor lightGrayColor];
        _guidePageView.bounces = NO;
        _guidePageView.pagingEnabled = YES;
        _guidePageView.showsHorizontalScrollIndicator = NO;
        _guidePageView.delegate = self;
        [self addSubview:_guidePageView];

    }
    return _guidePageView;
}

/**
 跳过按钮
 */
- (UIButton *)skipButton {
    if (_skipButton == nil) {
        _skipButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.8, SCREEN_WIDTH * 0.1, 50, 25)];
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_skipButton setBackgroundColor:[UIColor grayColor]];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton.layer setCornerRadius:(_skipButton.frame.size.height * 0.5)];
        [_skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

/**
 开始体验按钮
 */
- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.3, SCREEN_HEIGHT * 0.8, SCREEN_WIDTH * 0.4, SCREEN_HEIGHT * 0.08)];
        [_startButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor colorWithRed:164/255.0 green:201/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_startButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
        _startButton.layer.cornerRadius = SCREEN_HEIGHT * 0.2;
        [_startButton setBackgroundImage:[UIImage imageNamed:@"guideImage_button_backgound"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
    
}

/**
 PageControl
 */
- (UIPageControl *)imagePageControl {
    if (_imagePageControl == nil) {
        _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.0, SCREEN_HEIGHT * 0.9, SCREEN_WIDTH * 1.0, SCREEN_HEIGHT * 0.1)];
        _imagePageControl.currentPage = 0;
        _imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        _imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _imagePageControl.numberOfPages = self.imageArray.count;
    }
    return _imagePageControl;
}


#pragma mark –-------------------------- Action –--------------------------
- (void)buttonClick:(UIButton *)button {
    [self removeGuidePageHUD];
}

- (void)removeGuidePageHUD {
    if (self.guidePageCallBack) {
        self.guidePageCallBack();
    }
    [self removeFromSuperview];
}

#pragma mark –-------------------------- UIScrollViewDelegate–--------------------------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    if (self.imageArray && page == self.imageArray.count && self.slideInto == NO) {
        [self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count - 1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count - 1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 四舍五入,保证pageControl状态跟随手指滑动及时刷新
    [self.imagePageControl setCurrentPage:(int)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5f)];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end

