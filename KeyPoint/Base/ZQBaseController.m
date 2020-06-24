//
//  ZQBaseController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/14.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "ZQBaseController.h"

@interface ZQBaseController ()
@property (nonatomic, strong) QMUITips *tips;
@end

@implementation ZQBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    self.emptyView = [QMUIEmptyView new];
    self.emptyView.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    self.emptyView.loadingView.hidden = YES;
    self.emptyView.imageView.image = [UIImage imageNamed:@"empty"];
    self.emptyView.textLabel.text = @"不要着急, 冷静一下";
}

#pragma mark - Helper

- (void)toast:(NSString *)text {
    [QMUITips showWithText:text];
}

- (void)showLoading {
    self.tips = [QMUITips showLoading:nil inView:self.view];
}

- (void)hideLoading {
    [self.tips hideAnimated:YES];
}

- (void)showLoadingAndHideAfterDelay:(NSTimeInterval)seconds {
    [QMUITips showLoadingInView:self.view hideAfterDelay:seconds];
}

#pragma mark - UI

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (nullable NSString *)backBarButtonItemTitleWithPreviousViewController:(nullable UIViewController *)viewController {
    return @"";
}

- (BOOL)preferredNavigationBarHidden {
    return NO;
}

- (nullable UIColor *)navigationBarTintColor {
    return [UIColor colorWithRGB:0x1296db];
}

@end
