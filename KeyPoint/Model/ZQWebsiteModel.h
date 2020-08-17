//
//  ZQWebsiteModel.h
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ZQWebsiteState) {
    ZQWebsiteStateNone,
    ZQWebsiteStateCollected,
    ZQWebsiteModelRecommend,
};



@interface ZQWebsiteModel : ZQBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *sectionTitle;
//@property (nonatomic, assign) ZQWebsiteState state;
@end

NS_ASSUME_NONNULL_END
