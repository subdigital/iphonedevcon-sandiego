//
//  HelloViewController.m
//  hello-devcon
//
//  Created by Ben Scheirman on 9/28/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "HelloViewController.h"


@implementation HelloViewController


-(IBAction)buttonWasTapped {
	NSLog(@"buttonWasTapped");
	myFunkyLabel.text = @"You tapped it!";
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[myFunkyLabel release];
	
    [super dealloc];
}


@end
