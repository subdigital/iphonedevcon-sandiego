//
//  SamplePickerViewController.m
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/19/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SamplePickerViewController.h"
#import "sqlite_basicsViewController.h"

@implementation SamplePickerViewController


#pragma mark -
#pragma mark Initialization


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    samples = [[NSDictionary dictionaryWithObjectsAndKeys:
                @"sqlite_basicsViewController", @"Raw SQLite", 
                @"FMDBViewController",          @"FMDB",
                nil] retain];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [samples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString * sample = [[samples allKeys] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = sample;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sample = [[samples allKeys] objectAtIndex:indexPath.row];
    NSString *controllerName = [samples objectForKey:sample];
    Class class = NSClassFromString(controllerName);
    
    UIViewController *controller = [[class alloc] initWithNibName:controllerName bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [samples release];
    
    [super dealloc];
}


@end

