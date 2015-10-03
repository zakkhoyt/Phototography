//
//  ZHLocationSearchTableViewController.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void (^ZHLocationSearchTableViewControllerCoordinateBlock)(CLLocationCoordinate2D coordinate);

@interface ZHLocationSearchTableViewController : UITableViewController
@property (nonatomic, strong) MKMapView *mapView;
-(void)setCoordinateBlock:(ZHLocationSearchTableViewControllerCoordinateBlock)coordinateBlock;
@end


@interface ZHLocationSearchTableViewController (UISearchResultsUpdating) <UISearchResultsUpdating>

@end