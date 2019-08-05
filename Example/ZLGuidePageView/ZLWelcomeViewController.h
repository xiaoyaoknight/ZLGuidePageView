//
//  ZLWelcomeViewController.h
//  ZLGuidePageView
//
//  Created by 1017169400@qq.com on 08/02/2019.
//  Copyright (c) 2019 1017169400@qq.com. All rights reserved.
//

@import UIKit;

typedef void(^CallBack)(void);
@interface ZLWelcomeViewController : UIViewController

@property (nonatomic, copy) CallBack callBack;
@end
