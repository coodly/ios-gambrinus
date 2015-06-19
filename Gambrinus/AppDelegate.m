/*
* Copyright 2015 Coodly LLC
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "AppDelegate.h"
#import "ObjectModel.h"
#import "UIColor+Theme.h"
#import "Constants.h"
#import "BloggerAPIConnection.h"
#import "BlogImagesRetrieve.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Secrets.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Gambrinus-Swift.h"
#import "SideMenuViewController.h"
#import "Parse.h"
#import "ParseService.h"


@interface AppDelegate ()

@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [Parse setApplicationId:GambrinusParseApplicationId clientKey:GambrinusParseClientKey];
    [ParseService registerCustomClasses];

    [Fabric with:@[CrashlyticsKit]];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];

    ParseService *parse = [[ParseService alloc] init];
    [parse fetchChangesSinceDate:[NSDate distantPast]];

    CDYLog(@"DB path:%@", [model storeURL]);

    if (![model databaseFileExists]) {
        CDYLog(@"Copy DB file");
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gambrinus" withExtension:@"sqlite"];
        NSError *copyError = nil;
        [[NSFileManager defaultManager] copyItemAtURL:url toURL:model.storeURL error:&copyError];
        if (copyError) {
            CDYLog(@"Copy error:%@", copyError);
        }
    }

    BlogImagesRetrieve *imagesRetrieve = [[BlogImagesRetrieve alloc] init];
    BloggerAPIConnection *apiConnection = [[BloggerAPIConnection alloc] initWithBlogURLString:@"http://tartugambrinus.blogspot.com/" bloggerKey:GambrinusBloggerAPIKey objectModel:model];

    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setBarTintColor:[UIColor myOrange]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIRefreshControl appearance] setTintColor:[UIColor myOrange]];

    KioskSlideMenuViewController *controller = [[KioskSlideMenuViewController alloc] initWithMainViewController:[[UINavigationController alloc] init] leftMenuViewController:[[SideMenuViewController alloc] init]];
    NSLog(@"setting");
    [controller setObjectModel:model];
    [controller setBloggerAPIConnection:apiConnection];
    [controller setImagesRetrieve:imagesRetrieve];

    [self.window setRootViewController:controller];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setIdleTimerDisabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
