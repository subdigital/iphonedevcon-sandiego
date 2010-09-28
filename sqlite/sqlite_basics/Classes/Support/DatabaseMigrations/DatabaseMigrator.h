//
//  DatabaseMigrator.h
//  tailspin-iphone
//
//  Created by Ben Scheirman on 9/9/10.
//  Copyright (c) 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseMigrator : NSObject {
    NSString *dbPath;
    FMDatabase *db;
    NSArray *migrationFiles;
    NSInteger currentVersion;
}

-(id)initWithDatabasePath:(NSString *)dbPath inDocumentsDirectory:(BOOL)inDocumentsDirectory;
-(BOOL)databaseExists;
-(void)createDatabase;
-(void)runMigrations;

@end
