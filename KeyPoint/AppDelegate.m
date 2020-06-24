//
//  AppDelegate.m
//  KeyPoint
//
//  Created by Sam on 2020/6/10.
//  Copyright © 2020 Sam. All rights reserved.
//

#import "AppDelegate.h"
#import "ZQMainController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ZQMainController *main = [ZQMainController new];
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:main];
    UIWindow *w = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    w.rootViewController = nav;
    self.window = w;
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - UISceneSession lifecycle



@end
