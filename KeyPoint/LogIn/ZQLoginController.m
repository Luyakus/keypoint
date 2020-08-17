//
//  ZQLoginController.m
//  KeyPoint
//
//  Created by Sam on 2020/6/16.
//  Copyright © 2020 Sam. All rights reserved.
//
// M

// V

// C
#import "ZQLoginController.h"

// R
#import "ZQAuthcodeRequest.h"
#import "ZQLoginRequest.h"
@interface ZQLoginController ()
@property (nonatomic, weak) QMUITextField *usernameTf;
@property (nonatomic, weak) QMUITextField *authcodeTf;
@property (nonatomic, weak) UIButton *authcodeBtn;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, strong) RACDisposable *dispose;
@end
@implementation ZQLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    [self bind];
}

#pragma mark - 业务逻辑
- (void)bind {
    @weakify(self)
    [[self.usernameTf.rac_textSignal combineLatestWith:self.authcodeTf.rac_textSignal] subscribeNext:^(RACTwoTuple<NSString *, NSString *> * _Nullable x) {
        @strongify(self)
        if (x.first.length > 0 && x.second.length > 0) {
            self.loginBtn.userInteractionEnabled = YES;
            self.loginBtn.backgroundColor = [UIColor colorWithRGB:0x1296db];
        } else {
            self.loginBtn.userInteractionEnabled = NO;
            self.loginBtn.backgroundColor = [UIColor colorWithRGB:0xdddddd];
        }
    }];
    
    [[self.authcodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        if (self.usernameTf.text.length != 11) {
            [self toast:@"请输入正确的手机号"];
            return;
        }
        
        { // 验证码请求
            ZQAuthcodeRequest *r = [ZQAuthcodeRequest new];
            r.phoneNum = self.usernameTf.text;
            [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                if (r.resultCode == 1) {
                    [self toast:@"验证码已发送"];
                } else {
                    [self toast:r.errorMessage];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [self toast:@"获取验证码失败"];
            }];
        }
        
        
        { // 倒计时
            self.authcodeBtn.userInteractionEnabled = NO;
#if DEBUG
            __block NSInteger time = 5;
#else
            __block NSInteger time = 60;
#endif
            self.dispose = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] subscribeNext:^(NSDate * _Nullable x) {
                [self.authcodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)time] forState:UIControlStateNormal];
                time --;
                if (time == 0) {
                    self.authcodeBtn.userInteractionEnabled = YES;
                    [self.authcodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
                    [self.dispose dispose];
                }
            }];
        }
    }];
    
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        ZQLoginRequest *r = [ZQLoginRequest new];
        r.phoneNum = self.usernameTf.text;
        r.authcode = self.authcodeTf.text;
        [self showLoading];
        [r startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self hideLoading];
            if (r.resultCode == 1) {
                [self toast:@"登录成功"];
                ZQStatusDB.isLogin = YES;
                ZQStatusDB.signCode = r.responseJSONObject[@"sign"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self toast:r.errorMessage];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self hideLoading];
            [self toast:@"登录失败, 网络不通"];
        }];
    }];
   
}

#pragma mark - 准备工作
- (void)ui {
    self.title = @"登录";
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_avatar"]];
    avatar.layer.cornerRadius = 50;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderColor = [UIColor colorWithRGB:0x1296db].CGColor;
    avatar.layer.borderWidth = 2;
    [self.view addSubview:avatar];
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(self.view).offset(150);
    }];
    
    UIView *userNameHolder = [UIView new];
    userNameHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
    userNameHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
    userNameHolder.qmui_borderWidth = 2;
    userNameHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
    [self.view addSubview:userNameHolder];
    [userNameHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatar).offset(100);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(60);
    }];
    
    
    [userNameHolder addSubview:self.usernameTf];
    [self.usernameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(userNameHolder);
        make.left.equalTo(userNameHolder).offset(15);
        make.right.equalTo(userNameHolder).offset(-15);
    }];
    
    UIView *authcodeHolder = [UIView new];
    authcodeHolder.qmui_borderPosition = QMUIViewBorderPositionBottom;
    authcodeHolder.qmui_borderLocation = QMUIViewBorderLocationOutside;
    authcodeHolder.qmui_borderWidth = 2;
    authcodeHolder.qmui_borderColor = [UIColor colorWithRGB:0x1296db];
    [self.view addSubview:authcodeHolder];
    [authcodeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameHolder.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(60);
    }];

    [authcodeHolder addSubview:self.authcodeBtn];
    [self.authcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(authcodeHolder).offset(-15);
        make.bottom.equalTo(authcodeHolder);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
    
    [authcodeHolder addSubview:self.authcodeTf];
    [self.authcodeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(authcodeHolder);
        make.left.equalTo(authcodeHolder).offset(15);
        make.right.equalTo(self.authcodeBtn.mas_left).offset(-15);
    }];

    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(authcodeHolder.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
}

- (UIButton *)loginBtn {
    return _loginBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.backgroundColor = [UIColor colorWithRGB:0x1296db];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn = b;
        b;
    });
}



- (UIButton *)authcodeBtn {
    return _authcodeBtn ?: ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.titleLabel.font = [UIFont systemFontOfSize:13];
        [b setTitleColor:[UIColor colorWithRGB:0x1296db] forState:UIControlStateNormal];
        [b setTitle:@"验证码" forState:UIControlStateNormal];
        _authcodeBtn = b;
        b;
    });
}

- (QMUITextField *)usernameTf {
    return _usernameTf ?: ({
        QMUITextField *t = [[QMUITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"请输入手机号";
        
        _usernameTf = t;
        t;
    });
}

- (QMUITextField *)authcodeTf {
    return _authcodeTf ?: ({
        QMUITextField *t = [[QMUITextField alloc] initWithFrame:CGRectZero];
        t.placeholder = @"验证码";
        _authcodeTf = t;
        t;
    });
}


@end
