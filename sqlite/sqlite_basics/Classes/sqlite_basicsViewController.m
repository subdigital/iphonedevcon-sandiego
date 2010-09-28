//
//  sqlite_basicsViewController.m
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/8/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "sqlite_basicsViewController.h"
#import "sqlite3.h"
#import "Database.h"

@implementation sqlite_basicsViewController

@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.font = [UIFont fontWithName:@"Courier" size:11];
}

- (void)log:(NSString *)msg {
    self.textView.text = [[self.textView.text stringByAppendingString:msg] stringByAppendingString:@"\n"];
}

- (IBAction)insertSomeData:(id)sender {
    self.textView.text = @"";
    for(int i=0; i<10; i++) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO PETS(name) VALUES('Pet%d')", i];
        [self log:sql];
        [Database execute:sql];
    }
    
    [self log:@"...Done.  Inserted 10 rows."];
}

- (IBAction)queryTheTable:(id)sender {
    self.textView.text = @"";
    
    [self log:@"SELECT * FROM PETS"];
    [self log:@"------------------"];
    [self log:@" id  |  name      "];
    int count = 0;
    for(NSDictionary *row in [Database execute:@"SELECT * FROM PETS"]) {
        count++;
        [self log:[NSString stringWithFormat:@" %@  |  %@", [row valueForKey:@"id"], [row valueForKey:@"name"]]];
    }
    [self log:@"------------------"];
    [self log:[NSString stringWithFormat:@" %d records returned", count]];
}

- (void)viewDidUnload {
	self.textView = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
