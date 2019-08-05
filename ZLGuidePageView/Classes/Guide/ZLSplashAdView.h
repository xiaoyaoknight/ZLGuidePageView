//
//  ZLSplashAdView.h
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLaunchConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZLSplashAdViewDelegate <NSObject>

- (void)didClickAdImageVieWithSplash:(ZLLaunchConfig *)launchConfig;

@end

@interface ZLSplashAdView : UIView

/**
 * 需要显示的图
 */
@property (nonatomic, strong) UIImageView *adImageView;

/**
 logo图
 */
@property (nonatomic, strong) UIImageView *logoImageView;

/**
 * 跳过按钮
 */
@property (nonatomic, strong) UIButton *skipButton;

/**
 * 显示完成block
 */
@property (nonatomic, strong) dispatch_block_t finishedBlock;

/**
 配置url，倒计时等
 */
@property (nonatomic, strong) ZLLaunchConfig *launchConfig;

/**
 * 代理方法
 */
@property (nonatomic, weak) id<ZLSplashAdViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame launchConfig:(ZLLaunchConfig *)launchConfig;
@end


NS_ASSUME_NONNULL_END
