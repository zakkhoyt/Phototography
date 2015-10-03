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

@interface ZHMasterViewController ()

@end

@implementation ZHMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Nav bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //    self.navigationItem.rightBarButtonItem = addButton;
    //    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    // Table View
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.editing = NO;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 80;

    // Let's get started
    [self readAssets];

    
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

#pragma mark Private methods

-(void)checkPermissions{
    VWWPhotosPermission *photos = [VWWPhotosPermission permissionWithLabelText:@"We will read your photo library to find photos without a geotag."];
//    VWWCoreLocationWhenInUsePermission *locationWhenInUse = [VWWCoreLocationWhenInUsePermission permissionWithLabelText:@"For obtaining your current location"];
//    VWWCoreLocationAlwaysPermission *al = [VWWCoreLocationAlwaysPermission permissionWithLabelText:@"please"];
//    NSArray *permissions = @[al, photos];
    NSArray *permissions = @[photos];
    
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
    [[ZHAssetManager sharedInstance] getAssetsWithoutLocationWithCompletionBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(error){
            
        } else {
            self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",
                                         (unsigned long)[ZHAssetManager sharedInstance].assetsNoLocation.count,
                                         (unsigned long)[ZHAssetManager sharedInstance].assets.count];
            [self.tableView reloadData];
        }
    }];
}


//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SegueMasterToDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PHAsset *asset = [ZHAssetManager sharedInstance].assetsNoLocation[indexPath.row];
        ZHAssetDetailViewController *controller = (ZHAssetDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setAsset:asset];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.objects.count;
    return [ZHAssetManager sharedInstance].assetsNoLocation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PHAsset *object = [ZHAssetManager sharedInstance].assetsNoLocation[indexPath.row];
//    cell.textLabel.text = [object description];
    cell.textLabel.text = object.creationDate.description;
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

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}



@end
