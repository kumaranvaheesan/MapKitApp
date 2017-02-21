//
//  DetailViewController.m
//  iOS Maps Test
//
//  Created by kumaran V on 21/02/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.selectedLocationName;
    self.nameLabel.text = self.selectedLocationName;
    self.latLabel.text = self.Lat;
    self.lngLabel.text = self.Lng;
    self.textView.layer.borderWidth = 2.0f;
    self.textView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.textView.text = self.notes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNotes:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePaths = [documentsDirectory stringByAppendingPathComponent:@"locationArray.plist"];
    NSMutableArray *locations = [ self.locationsDictionary objectForKey:@"locations"];

   
    
    for (NSMutableDictionary *dict in locations) {
        if([[dict objectForKey:@"name"] isEqualToString:_selectedLocationName] ==  true)
        {
            [dict setObject:_textView.text forKey:@"notes"];
            NSLog(@"dictionary %@",dict);
        }
    }
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                            
                                                          timeStyle:NSDateFormatterFullStyle];
    
    NSMutableDictionary *jsondictionary  = [[NSMutableDictionary alloc] init];
    [jsondictionary setObject:locations forKey:@"locations"];
    [jsondictionary setObject:dateString forKey:@"updated"];
    
    

    
    BOOL success = [jsondictionary writeToFile:filePaths atomically:YES];
    
    
    NSDictionary *array = [NSDictionary dictionaryWithContentsOfFile:filePaths];
    NSLog(@"array detail %d - %@",success,array);
}


@end
