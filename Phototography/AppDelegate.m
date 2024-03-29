//
//  AppDelegate.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHAssetDetailViewController.h"
#import "UIColor+ZH.h"


@interface AppDelegate () <UISplitViewControllerDelegate>
@end

@interface AppDelegate (Notifications)
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // TODO: Check for UIApplicationLaunchOptionsLocationKey
    
    
    
    self.cloudManager = [[ZHCloudManager alloc]init];
    
    [self setupAppearance];
    
#if defined(ZH_MASTER_DETAIL)
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#if defined(ZH_MASTER_DETAIL)
#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[ZHAssetDetailViewController class]] && ([(ZHAssetDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] asset] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}



#endif

-(void)setupAppearance{
    
    
    // UIView (this is what controls the color of the back button arrow)
    [[UIView appearance] setTintColor:[UIColor zhTintColor]];
    //    [[UIView appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor zhBackgroundColor]];
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTintColor:[UIColor zhBackgroundColor]];
    
    // UILabel
    [[UILabel appearance] setTextColor:[UIColor zhGreenColor]];
    
    // Navigation bar
    NSDictionary *navBarAttributes = @{NSForegroundColorAttributeName : [UIColor zhBackgroundColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navBarAttributes];
    [[UINavigationBar appearance] setBarTintColor:[UIColor zhTintColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor zhBackgroundColor]];
    // The nav bar back button
    [[UIBarButtonItem appearance] setTitleTextAttributes:navBarAttributes forState:UIControlStateNormal];
    
    // Tabbar
    [[UITabBar appearance] setBarTintColor:[UIColor zhTintColor]];
    [[UITabBar appearance] setTintColor:[UIColor zhBackgroundColor]];
    
    // TabbarItem
    NSDictionary *tabBarAttributes = @{NSForegroundColorAttributeName : [UIColor zhBackgroundColor]};
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarAttributes forState:UIControlStateNormal];
    
    // Segmented control
    NSDictionary *segmentAttributes = @{NSForegroundColorAttributeName : [UIColor zhTintColor],
                                        NSStrokeColorAttributeName : [UIColor zhBackgroundColor]};
    [[UISegmentedControl appearance] setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
    
    // Toolbar
    [[UIToolbar appearance] setBarTintColor:[UIColor zhBackgroundColor]];
    [[UIToolbar appearance] setTintColor:[UIColor zhTintColor]];
    
    // Text controls
    [[UITextView appearance] setTextColor:[UIColor zhDarkTextColor]];
    [[UITextView appearance] setBackgroundColor:[UIColor zhBackgroundColor]];
    
    [[UITextField appearance] setTextColor:[UIColor zhDarkTextColor]];
    [[UITextField appearance] setBackgroundColor:[UIColor zhBackgroundColor]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor zhBackgroundColor]];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor zhBackgroundColor]];
    
    [[UICollectionView appearance] setBackgroundColor:[UIColor zhBackgroundColor]];
    [[UICollectionViewCell appearance]setBackgroundColor:[UIColor zhBackgroundColor]];
    
    [[UIButton appearance] setTintColor:[UIColor zhTintColor]];
    [[UIButton appearance] setTitleColor:[UIColor zhTintColor] forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor zhTintColor]];
}
@end




@implementation AppDelegate (Notifications)
-(void)application:(nonnull UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)pushToken {
    // Format the push token
    NSString *pushTokenString = [pushToken description];
    pushTokenString = [pushTokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushTokenString = [pushTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(pushTokenString){
        NSLog(@"Registered for push notifications with token: %@", pushTokenString);
    } else {
        NSLog(@"Registered for push notifications but was not issued an apsToken. Returning...");
    }
}



-(void)application:(nonnull UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{
    NSLog(@"Registered for user notifications");
    [application registerForRemoteNotifications];
}

-(void)application:(nonnull UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"Error! Failed to register for remote notifications");
}

-(void)application:(nonnull UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSLog(@"Received local notification with userInfo: %@", notification.userInfo.description);
}

-(void)application:(nonnull UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    NSLog(@"Received remote notification with userInfo: %@", userInfo.description);
}

// Good reading about handling notifications: http://www.annema.me/problems-with-ios-push-notifications
-(void)application:(nonnull UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Received remote notification with userInfo: %@", userInfo.description);
    
    // Currently there is no need to wait around. Consider adding completion block to handleNot:
    completionHandler(UIBackgroundFetchResultNoData);
}


#pragma mark Private helpers

-(void)handleNotificationDictionary:(NSDictionary*)dictionary {
    //    [PKNotificationManager sharedInstance] receivedNotification
}


@end



@implementation AppDelegate (Utility)

-(void)setupNotifications{
    
    // Register for remote notificaitons
    UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                    UIUserNotificationTypeSound|
                                    UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}



-(NSString*)buildAndVersionString{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* appVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* appBuild = [bundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return [NSString stringWithFormat:@"v%@ b%@", appVersion, appBuild];
}
-(NSString*)executableString{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *executable = [bundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
    return executable;
}

@end
