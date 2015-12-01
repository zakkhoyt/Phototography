//
//  ZHUpdatesViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUpdatesViewController.h"
#import "ZHLocationUpdate.h"
#import "ZHLocationManager.h"
#import "ZHUpdateTableViewCell.h"

@interface ZHUpdatesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface ZHUpdatesViewController (UITableViewDataSource) <UITableViewDataSource>
@end

@interface ZHUpdatesViewController (UITableViewDelegate) <UITableViewDelegate>
@end

@implementation ZHUpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (IBAction)updateLocationBarButtonAction:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
#if TARGET_IPHONE_SIMULATOR
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.75 longitude:-122.45];
    [[ZHLocationManager sharedInstance] updateToLocation:location completionBlock:^(CLLocation *location, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
#else
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
#endif
    
}

@end


@implementation ZHUpdatesViewController (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZHLocationManager sharedInstance].updates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHUpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZHUpdateTableViewCell"];
    cell.update = [ZHLocationManager sharedInstance].updates[indexPath.row];
    return cell;
}

@end


@implementation ZHUpdatesViewController (UITableViewDelegate)

@end
