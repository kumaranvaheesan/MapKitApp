//
//  FirstViewController.m
//  iOS Maps Test
//
//  Created by kumaran V on 21/02/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"

@interface FirstViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.tabBarController.navigationItem.title = @"Map View";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePaths = [documentsDirectory stringByAppendingPathComponent:@"locationArray.plist"];
    self.locationsDictionary = [[NSMutableDictionary alloc] init];
    self.locationsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePaths];
    
    
    if([self.locationsDictionary count] == 0)
    {
        NSLog(@"no user added data. load defaults");
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.locationsDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSArray *locations = [self.locationsDictionary objectForKey:@"locations"];
        for (NSDictionary *dict in locations) {
            CLLocationCoordinate2D location;
            location.latitude = [[dict objectForKey:@"lat"] doubleValue];
            location.longitude  = [[dict objectForKey:@"lng"] doubleValue];
            [self addPins:location  withTitle:[dict objectForKey:@"name"]];
        }
        
    }
    
    else
    {
        NSLog(@"defaults already added");
        NSArray *locations = [self.locationsDictionary objectForKey:@"locations"];
        for (NSDictionary *dict in locations) {
            CLLocationCoordinate2D location;
            location.latitude = [[dict objectForKey:@"lat"] doubleValue];
            location.longitude  = [[dict objectForKey:@"lng"] doubleValue];
            [self addPins:location  withTitle:[dict objectForKey:@"name"]];
        }
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self enableLocationServices];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2.0;
    [self.mapView addGestureRecognizer:longPress];
    
}

-(void)enableLocationServices
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
}

-(void)addPins:(CLLocationCoordinate2D)location withTitle:(NSString *)title
{
    NSString *display_coordinates=[NSString stringWithFormat:@"Latitude is %f and Longitude is %f",location.longitude,location.latitude];
    NSLog(@"receive coordinates %@",display_coordinates);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [annotation setTitle:title];
    
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *mapPin = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
        {
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                     reuseIdentifier:defaultPinID];
            mapPin.canShowCallout = YES;
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            mapPin.rightCalloutAccessoryView = infoButton;
        }
        else
            mapPin.annotation = annotation;
        
    }
    return mapPin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSArray *locations = [self.locationsDictionary objectForKey:@"locations"];
    detailVC.locationsDictionary = self.locationsDictionary;
    detailVC.selectedLocationName = view.annotation.title;
    detailVC.Lat = [NSString stringWithFormat:@"%f",view.annotation.coordinate.latitude];
    detailVC.Lng = [NSString stringWithFormat:@"%f",view.annotation.coordinate.longitude];
    
    for (NSMutableDictionary *dict in locations) {
        if([[dict objectForKey:@"name"] isEqualToString:view.annotation.title] ==  true)
        {
            detailVC.notes = [dict objectForKey:@"notes"];
        }
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchedMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Add Location"
                                  message:@"Enter Title For This Location"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                                                   [annotation setCoordinate:touchedMapCoordinate];
                                                   [annotation setTitle:((UITextField *)[alert.textFields objectAtIndex:0]).text];
                                                   [self.mapView addAnnotation:annotation];
                                                   [self writeToJSON:touchedMapCoordinate withTitle:annotation.title];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Title";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(BOOL)writeToJSON:(CLLocationCoordinate2D)location withTitle:(NSString *)title
{
    
    NSMutableArray *locations = [[self.locationsDictionary objectForKey:@"locations"] mutableCopy];
    
    
    NSMutableDictionary* newLocation = [[NSMutableDictionary alloc] init];
    [newLocation setObject:[NSNumber numberWithDouble: location.latitude] forKey:@"lat"];
    [newLocation setObject:[NSNumber numberWithDouble: location.longitude] forKey:@"lng"];
    [newLocation setObject:title forKey:@"name"];
    [locations addObject:newLocation];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                            
                                                          timeStyle:NSDateFormatterFullStyle];
    
    NSMutableDictionary *jsondictionary  = [[NSMutableDictionary alloc] init];
    [jsondictionary setObject:locations forKey:@"locations"];
    [jsondictionary setObject:dateString forKey:@"updated"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePaths = [documentsDirectory stringByAppendingPathComponent:@"locationArray.plist"];
    
    BOOL success =  [jsondictionary writeToFile:filePaths atomically:YES];
    return success;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
