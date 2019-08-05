//
//  ZLLaunchConfig.h
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLLaunchConfig : NSObject

/**
 *  图片地址
 */
@property (nonatomic, copy) NSString *pic;

/**
 * 自定义的logoImage
 */
@property (nonatomic, copy) NSString *logoImage;

/**
 是否隐藏跳过按钮
 */
@property (nonatomic, assign) BOOL hideSkip;

/**
 倒计时
 */
@property (nonatomic, assign) CGFloat delayTime;

/**
 图片点击链接
 */
@property (nonatomic, copy) NSString *links;
@end

NS_ASSUME_NONNULL_END
