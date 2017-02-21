//
//  DetailViewController.h
//  iOS Maps Test
//
//  Created by kumaran V on 21/02/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *latLabel;
@property (strong, nonatomic) IBOutlet UILabel *lngLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic, strong) NSMutableDictionary *locationsDictionary;
@property(nonatomic, strong) NSString *selectedLocationName;
@property(nonatomic, strong) NSString *Lat;
@property(nonatomic, strong) NSString *Lng;
@property(nonatomic, strong) NSString *notes;





@end
