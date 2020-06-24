//
//  ZQUserInfoModel.h
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@interface ZQSocialAccountModel : ZQKeyPointBaseModel
//@property (nonatomic, copy) NSString *company;
//@property (nonatomic, assign) BOOL hasBind;
//@end

@interface ZQUserInfoModel : ZQBaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) BOOL isMale;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSSet *account;
//@property (nonatomic, copy) ZQSocialAccountModel *socialAccount;
@property (nonatomic, copy) NSString *identifierLink;

@end

NS_ASSUME_NONNULL_END
