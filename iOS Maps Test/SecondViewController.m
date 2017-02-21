//
//  SecondViewController.m
//  iOS Maps Test
//
//  Created by kumaran V on 21/02/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "SecondViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableDictionary *locationsDictionary;
@property(nonatomic, strong) CLLocation *currentLocation;

@end

@implementation SecondViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePaths = [documentsDirectory stringByAppendingPathComponent:@"locationArray.plist"];
    self.tabBarController.navigationItem.title = @"List View";
    self.locationsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filePaths];
    NSLog(@"json %@", self.locationsDictionary);
    
    
    if([self.locationsDictionary count] == 0)
    {
        NSLog(@"no user added data. load defaults");
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.locationsDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    else
    {
        NSLog(@"defaults already added");
        NSArray *locations = [ self.locationsDictionary objectForKey:@"locations"];
        for (NSDictionary *dict in locations) {
            CLLocationCoordinate2D location;
            location.latitude = [[dict objectForKey:@"lat"] doubleValue];
            location.longitude  = [[dict objectForKey:@"lng"] doubleValue];
        }
        
    }
    [self.locationsTableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationsTableView.delegate = self;
    self.locationsTableView.dataSource = self;
    self.locationsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.locationsTableView.bounds.size.width, 0.01f)];
}

#pragma mark tableview delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.locationsDictionary objectForKey:@"locations"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewIdentifier = @"locationTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tableViewIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSArray *locations = [self.locationsDictionary objectForKey:@"locations"];
    cell.textLabel.text = [[locations objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.numberOfLines = 0;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    NSArray *locations = [self.locationsDictionary objectForKey:@"locations"];
    detailVC.locationsDictionary = self.locationsDictionary;
    detailVC.selectedLocationName = selectedCell.textLabel.text;
    detailVC.Lat = [NSString stringWithFormat:@"%@",[[locations objectAtIndex:indexPath.row] objectForKey:@"lat"]];
    detailVC.Lng = [NSString stringWithFormat:@"%@",[[locations objectAtIndex:indexPath.row] objectForKey:@"lng"]];
    detailVC.notes = [[locations objectAtIndex:indexPath.row] objectForKey:@"notes"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


@end
