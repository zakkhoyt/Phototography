//
//  MasterViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHMasterViewController.h"
#import "ZHAssetDetailViewController.h"
#import "ZHAssetManager.h"
#import "VWWPermissionKit.h"
#import "MBProgressHUD.h"
#import "NSDate+ZH.h"

typedef enum {
    ZHMasterViewControllerModeAssets = 0,
    ZHMasterViewControllerModeMoments = 1,
} ZHMasterViewControllerMode;

@interface ZHMasterViewController ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) ZHMasterViewControllerMode mode;
@property (nonatomic, strong) NSMutableOrderedSet *selectedIndexPaths;
@end

@implementation ZHMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Nav bar
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *modeButton = [[UIBarButtonItem alloc]initWithTitle:@"Mode" style:UIBarButtonItemStylePlain target:self action:@selector(modeBarButtonAction:)];
    self.navigationItem.leftBarButtonItem = modeButton;


    // Data
    self.mode = ZHMasterViewControllerModeMoments;
    self.selectedIndexPaths = [[NSMutableOrderedSet alloc]init];
    
    // Table View
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.editing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;

    // Let's get started
    [self readAssets];

    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self checkPermissions];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueMasterToDetail"]) {
        ZHAssetDetailViewController *controller = (ZHAssetDetailViewController *)[[segue destinationViewController] topViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        if(self.mode == ZHMasterViewControllerModeAssets){
            PHAsset *asset = [ZHAssetManager sharedInstance].assetsNoLocation[indexPath.row];
            [controller setAsset:asset];
        } else if(self.mode == ZHMasterViewControllerModeMoments) {
            NSDictionary *dictionary = self.items[indexPath.row];
            PHAssetCollection *moment = dictionary[@"moment"];
            NSMutableArray *assets = dictionary[@"assets"];
            [controller setMoment:moment assets:assets];
        }
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
#pragma mark Private methods

-(void)checkPermissions{
    VWWPhotosPermission *photos = [VWWPhotosPermission permissionWithLabelText:@"We will read your photo library to find photos without a geotag."];
//    VWWCoreLocationWhenInUsePermission *locationWhenInUse = [VWWCoreLocationWhenInUsePermission permissionWithLabelText:@"For obtaining your current location"];
    VWWCoreLocationAlwaysPermission *locationAlways = [VWWCoreLocationAlwaysPermission permissionWithLabelText:@"please"];
    NSArray *permissions = @[locationAlways, photos];
//    NSArray *permissions = @[photos];
    
    [VWWPermissionsManager requirePermissions:permissions
                                       title:@"Welcome to the Phototography! A tool to add geotags to your Apple Photo collection. Approve these permissions, then we can get started."
                          fromViewController:self
                                resultsBlock:^(NSArray *permissions) {
                                    [permissions enumerateObjectsUsingBlock:^(VWWPermission *permission, NSUInteger idx, BOOL *stop) {
                                        NSLog(@"%@ - %@", permission.type, [permission stringForStatus]);
                                    }];
                                }];
}

-(void)readAssets{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Reading...";
    
    if(self.mode == ZHMasterViewControllerModeAssets){
        [[ZHAssetManager sharedInstance] getAssetsWithoutLocationWithCompletionBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(error){
                NSLog(@"Error reading assets");
            } else {
                self.items = [ZHAssetManager sharedInstance].assetsNoLocation;
                
                self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",
                                             (unsigned long)[ZHAssetManager sharedInstance].assetsNoLocation.count,
                                             (unsigned long)[ZHAssetManager sharedInstance].assets.count];
                [self.tableView reloadData];
            }
        }];
        
    } else if(self.mode == ZHMasterViewControllerModeMoments){
        [[ZHAssetManager sharedInstance] getMomentsWithoutLocationWithCompletionBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(error){
                NSLog(@"Error reading moments");
            } else {
                self.items = [ZHAssetManager sharedInstance].moments;
                self.navigationItem.title = [NSString stringWithFormat:@"%lu", self.items.count];
                [self.tableView reloadData];
            }
        }];
    }
}


//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}


#pragma mark IBActions
-(void)modeBarButtonAction:(UIBarButtonItem*)sender{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:self.mode == ZHMasterViewControllerModeAssets ? @"👍🏼 Assets 👍🏼" : @"Assets" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.mode = ZHMasterViewControllerModeAssets;
        [self readAssets];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:self.mode == ZHMasterViewControllerModeMoments ? @"👍🏼 Moments 👍🏼" : @"Moments" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.mode = ZHMasterViewControllerModeMoments;
        [self readAssets];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:ac animated:YES completion:NULL];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if([self.selectedIndexPaths containsObject:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(self.mode == ZHMasterViewControllerModeAssets){
        PHAsset *asset = self.items[indexPath.row];
        //    cell.textLabel.text = [object description];
        cell.textLabel.text = asset.creationDate.description;
        cell.textLabel.text = [asset.creationDate stringFromDateAndTime];
    } else if(self.mode == ZHMasterViewControllerModeMoments) {
        
        NSDictionary *dictionary = self.items[indexPath.row];
        PHAssetCollection *moment = dictionary[@"moment"];
        NSMutableArray *assets = dictionary[@"assets"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (#%lu)", [moment.startDate stringFromDateAndTime] , (unsigned long)assets.count];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedIndexPaths addObject:indexPath];
    NSLog(@"%lu selected", (unsigned long)self.selectedIndexPaths.count);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.selectedIndexPaths removeObject:indexPath];
    NSLog(@"%lu selected", (unsigned long)self.selectedIndexPaths.count);
}



@end
