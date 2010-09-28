//
//  sqlite_basicsAppDelegate.m
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/8/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


#import "AppDelegate.h"
#import "Database.h"
#import "DatabaseMigrator.h"

@implementation sqlite_basicsAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    if (![Database databaseExists]) {
        [Database createDatabase:@"CREATE TABLE PETS(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(50) NOT NULL)"];
        NSLog(@"Database created!");
    }
    
    
    DatabaseMigrator *migrator = [[DatabaseMigrator alloc] initWithDatabasePath:@"app.db" inDocumentsDirectory:YES];
    
    if(![migrator databaseExists]) {
        [migrator createDatabase];
    }
    
    [migrator runMigrations];
    
    [migrator release];
    
    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {   

    [window release];
    [viewController release];
    [super dealloc];
}

@end

