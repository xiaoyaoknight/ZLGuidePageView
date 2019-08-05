//
//  UIImage+LaunchImage.m
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "UIImage+LaunchImage.h"

@implementation UIImage (LaunchImage)

+ (UIImage *)getTheLaunchImage {
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) ||
        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    
    NSString *launchImage = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

@end
