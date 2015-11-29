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

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (IBAction)updateLocationBarButtonAction:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
}

@end


@implementation ZHUpdatesViewController (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZHLocationManager sharedInstance].updates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
    ZHLocationUpdate *update = [ZHLocationManager sharedInstance].updates[indexPath.row];
    cell.textLabel.text = [update.date stringRelativeTimeFromDate];
    
    cell.detailTextLabel.text = @"";
    [update.location stringLocalityCompletionBlock:^(NSString *string) {
        cell.detailTextLabel.text = string;
    }];
    
    return cell;
}

@end


@implementation ZHUpdatesViewController (UITableViewDelegate)

@end
