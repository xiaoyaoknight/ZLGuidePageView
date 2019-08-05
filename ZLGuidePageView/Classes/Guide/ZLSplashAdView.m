//
//  ZLSplashAdView.m
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "ZLSplashAdView.h"
#import "UIImage+LaunchImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MSWeakTimer/MSWeakTimer.h>
#import "AppMacro.h"

static const CGFloat defaultSplashTime = 5.0f;

@interface ZLSplashAdView ()

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) MSWeakTimer *closeTimer;

@end

@implementation ZLSplashAdView

- (instancetype)initWithFrame:(CGRect)frame launchConfig:(ZLLaunchConfig *)launchConfig; {

    if (self = [super initWithFrame:frame]) {
        self.launchConfig = launchConfig;
        self.backgroundColor = [UIColor whiteColor];
    
        if (launchConfig.pic.length) {
            __weak __typeof(self)weakSelf = self;
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:launchConfig.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.adImageView.image = image;
                [strongSelf startCoundown];
                strongSelf.skipButton.hidden = launchConfig.hideSkip;
                
            }];
        }

        [self addSubview:self.skipButton];
        self.logoImageView.image = [UIImage imageNamed:launchConfig.logoImage];
        
        if (!self.closeTimer) {
            // 默认5秒倒计时
            int time = launchConfig.delayTime ? launchConfig.delayTime : defaultSplashTime;
            self.closeTimer = [MSWeakTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(removeView)
                                                                 userInfo:nil
                                                                  repeats:NO
                                                            dispatchQueue:dispatch_get_main_queue()];
        }
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

#pragma mark –-------------------------- Action –--------------------------
- (void)adImageViewTapped:(UITapGestureRecognizer *)gesture {
    
    [self dismiss];
    if(self.launchConfig.links != nil && self.launchConfig.links.length != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 点击图片实现代理方法 // 跳转逻辑放在代理中去自己实现
            if([self.delegate respondsToSelector:@selector(didClickAdImageVieWithSplash:)]) {
                [self.delegate didClickAdImageVieWithSplash:self.launchConfig];
            }
        });
    }
}

/**
 * 倒计时
 */
- (void)startCoundown {
    __block NSInteger timeout = self.launchConfig.delayTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.skipButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)timeout] forState:UIControlStateNormal];
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

/**
 动画diss
 */
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeView];
    }];
}

/**
 * 关闭启动广告图
 */
- (void)removeView {
    [self invalidTimer];
    [self removeFromSuperview];
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}

/**
 * 停止定时器
 */
- (void)invalidTimer {
    [self.closeTimer invalidate];
    self.closeTimer = nil;
}

#pragma mark –-------------------------- Setter/Getter –--------------------------

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - AutoSize6(186))];
        _adImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        _adImageView.userInteractionEnabled = YES;
        [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTapped:)]];
        [self addSubview:_adImageView];
    }
    
    return _adImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        CGFloat top = AutoSize6(40);
        if (IS_IPHONEX) {
            top += AutoSize6(40);
        }
        _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - AutoSize6(140), top, AutoSize6(120), AutoSize6(42))];
        [_skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _skipButton.hidden = YES;
    }
    
    return _skipButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImage *image = [UIImage getTheLaunchImage];
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.adImageView.frame), self.bounds.size.width, self.bounds.size.height - self.adImageView.bounds.size.height)];
        _logoImageView.image = image;
        _logoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_logoImageView];
    }
    return _logoImageView;
}

- (void)skipButtonPressed:(UIButton *)btn {
    [self dismiss];
}

- (void)dealloc {
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
}
@end

