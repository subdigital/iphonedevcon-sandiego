//
//  FMDBViewController.h
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/19/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface FMDBViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView;
    NSMutableArray *pets;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)insertPets:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)clearData:(id)sender;

@end
