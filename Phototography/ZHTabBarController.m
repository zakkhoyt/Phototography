//
//  ZHTabBarController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHTabBarController.h"
#import "ZHViewControllerImports.h"

@interface ZHTabBarController ()

@end

@interface ZHTabBarController (UITabBarDelegate) <UITabBarDelegate>
@end



@implementation ZHTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupTabBarIcons];
//    [self registerForPushNotifications];
    [self setSelectedIndex:1];
}



-(void)setupTabBarIcons{

    self.tabBar.itemPositioning = UITabBarItemPositioningAutomatic;
    
    
    for(NSUInteger index = 0; index < self.viewControllers.count; index++){
        UITabBarItem *item = self.tabBar.items[index];
        switch (index) {
//            case 0:{
//                item.image = [[UIImage imageNamed:@"ic_map"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_map_selected"];
//                break;
//            }
//            case 1:{
//                item.image = [[UIImage imageNamed:@"ic_ping"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_ping_selected"];
//            }
//                break;
//            case 2:{
//                item.image = [[UIImage imageNamed:@"ic_profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_profile_selected"];
//            }
//                break;
            case 0:{
                item.image = [[UIImage imageNamed:@"tab_map"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_map_selected"];
                break;
            }
            case 1:{
                item.image = [[UIImage imageNamed:@"tab_updates"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_ping_selected"];
            }
                break;
            case 2:{
                item.image = [[UIImage imageNamed:@"tab_you"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                item.selectedImage = [UIImage imageNamed:@"ic_profile_selected"];
            }
                break;

            default:
                break;
        }
        [self.tabBar setNeedsDisplay];
    }
}

-(void)registerForPushNotifications{
 
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setupNotifications];

}

@end

@implementation ZHTabBarController (UITabBarDelegate)

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSDictionary *userInfo = @{@"selectedIndex": @(self.tabBarController.selectedIndex),
//                               @"tabCount": @(self.tabBar.items.count)};
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarSelectedIndexChanged" object:nil userInfo:userInfo];
}

@end
