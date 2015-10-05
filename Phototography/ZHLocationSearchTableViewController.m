//
//  ZHLocationSearchTableViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHLocationSearchTableViewController.h"
#import "UIColor+ZH.h"

@import MapKit;

@interface ZHLocationSearchTableViewController ()
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) ZHLocationSearchTableViewControllerCoordinateBlock coordinateBlock;
@end


@interface ZHLocationSearchTableViewController (UITableViewDataSource) <UITableViewDataSource>
@end

@interface ZHLocationSearchTableViewController (UITableViewDelegate) <UITableViewDelegate>
@end


@implementation ZHLocationSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)setCoordinateBlock:(ZHLocationSearchTableViewControllerCoordinateBlock)coordinateBlock{
    _coordinateBlock = coordinateBlock;
}


-(void)filterMomentsWithString:(NSString*)string{
    
    [self.tableView reloadData];
}

-(void)locationsFromAddress:(NSString*)addressString{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.region = self.mapView.region;
    request.naturalLanguageQuery = addressString;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.places = response.mapItems;
        [self.tableView reloadData];
    }];
}


@end


@implementation ZHLocationSearchTableViewController (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"place"];
    MKMapItem *place = self.places[indexPath.row];
    cell.textLabel.text = place.name;
    return cell;
}

@end

@implementation ZHLocationSearchTableViewController (UITableViewDelegate)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PHAssetCollection *moment = self.filteredMoments[indexPath.row];
//    if(self.selectedMomentBlock){
//        _selectedMomentBlock(moment);
//    }
    
    MKMapItem *place = self.places[indexPath.row];
    if(_coordinateBlock){
        _coordinateBlock(place.placemark.location.coordinate);
    }
}

@end



@implementation ZHLocationSearchTableViewController (UISearchResultsUpdating)

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if(searchController.active == NO){
        return ;
    }
    
    [self locationsFromAddress:searchController.searchBar.text];
}

@end
