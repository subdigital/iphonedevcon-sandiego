//
//  FMDBViewController.m
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/19/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FMDBViewController.h"
#import "Database.h"

@implementation FMDBViewController

@synthesize tableView;

#pragma mark -
#pragma mark Data access

- (FMDatabase *)db {
    NSString *path = [Database databasePath]; 
    return [FMDatabase databaseWithPath:path];
}

- (void)loadPets {
    if(!pets) {
        pets = [[NSMutableArray alloc] init];
    } else {
        [pets removeAllObjects];
    }
    
    FMDatabase *db = [self db];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM pets"];
    while([rs next]) {
        NSString *pet = [rs stringForColumn:@"name"];
        [pets addObject:pet];
    }
    
    [db close];
}

- (void)deletePets {
    FMDatabase *db = [self db];
    [db open];
    [db executeUpdate:@"DELETE FROM pets"];
    [db close];
    [pets removeAllObjects];
}

- (void)addPets:(int)count {
    FMDatabase *db = [self db];
    [db open];
    
    NSArray *names = [NSArray arrayWithObjects:@"Fido", @"Max", @"Lassie", @"Rex", @"Spot", @"Killer", @"Mr. Whiskers", nil];
    for(int i=0; i<count; i++) {
        NSString *name = [names objectAtIndex: arc4random() % [names count]];
        [db executeUpdate:@"INSERT INTO pets(name) values(?)", name];
    }
    
    [db close];
}

#pragma mark -
#pragma mark button handlers

- (IBAction)insertPets:(id)sender {
    [self addPets:10];
}

- (IBAction)refresh:(id)sender {
    [self loadPets];
    [tableView reloadData];
}

- (IBAction)clearData:(id)sender {
    [self deletePets];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDB";
    [self loadPets];
}

#pragma mark -
#pragma mark table view datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {

    return [pets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.textLabel.text = [pets objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark table view delegate methods



- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


- (void)dealloc {
    [pets release];
    [super dealloc];
}


@end
