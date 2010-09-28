//
//  DatabaseMigrator.m
//  tailspin-iphone
//
//  Created by Ben Scheirman on 9/9/10.
//  Copyright (c) 2010 ChaiONE. All rights reserved.
//

#import "DatabaseMigrator.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FileHelpers.h"

@implementation DatabaseMigrator

-(id)initWithDatabasePath:(NSString *)databasePath inDocumentsDirectory:(BOOL)inDocumentsDirectory {
    if ((self == [super init])) {
        if(inDocumentsDirectory) {
            NSLog(@"Documents dir: %@", DocumentsDirectory());
            dbPath = [[DocumentsDirectory() stringByAppendingPathComponent:databasePath] retain];
        } else {
            dbPath = [databasePath copy];            
        }
                
        NSLog(@"Initializing database at path: %@", dbPath);
        db = [[FMDatabase alloc] initWithPath:dbPath];
        currentVersion = -1; //signify that we haven't checked yet
    }

    return self;
}

-(void)setSchemaVersion:(int)newVersion {
    NSString *sql = [NSString stringWithFormat:@"PRAGMA USER_VERSION=%d", newVersion];
    NSLog(@"%@", sql);
    [db executeUpdate:sql];
    currentVersion = newVersion;
    if ([db hadError]) {
        [NSException raise:@"Migration error" format:@"ERROR: %@", [db lastErrorMessage]];
    }   
}

-(int)schemaVersion {
    if(currentVersion != -1) {
        return currentVersion;
    }
    
    currentVersion = [db intForQuery:@"PRAGMA USER_VERSION"];
    return currentVersion;    
}

-(BOOL)databaseExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
}

-(void)createDatabase {
    if([self databaseExists])
        return;
    
    NSLog(@"Creating database at path: %@", dbPath);
    
    if(![db open]) {
        [NSException raise:@"SQLITE ERROR" format:@"Error opening database!"];
    }
    
    [self setSchemaVersion:0];
    [db close];
}

-(NSArray *)sortFiles:(NSArray *)files {
    NSSortDescriptor *sortBySelf = [[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease];
    return [files sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortBySelf]];
}

-(NSString *)migrationPath {
    return [[NSBundle mainBundle] resourcePath];
}

-(NSArray *)migrations {
    if(migrationFiles)
        return migrationFiles;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *files = [fm contentsOfDirectoryAtPath:[self migrationPath] error:nil];
    NSMutableArray *sqlFiles = [NSMutableArray array];
    for(NSString *file in files) {
        if([[file substringFromIndex:[file length] - 4] isEqualToString:@".sql"]) {
            [sqlFiles addObject:file];
            NSLog(@"Found migration %@", file);
        }
    }
    
    migrationFiles = [sqlFiles retain];
    return migrationFiles;    
}

-(int)maxMigration {
    return [[self migrations] count];
}

-(NSString *)migrationForVersion:(int)version {
    NSArray *migrations = [self migrations];
    if(version == 0 && version > [migrations count] + 1) {
        [NSException raise:@"Invalid Migration #!" format:@"The migration array has %d elements, and # %d was requested", [migrations count], version];
    } 

    NSString *migrationFile = [migrations objectAtIndex:version-1];
    NSString *path = [[self migrationPath] stringByAppendingPathComponent:migrationFile];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

-(void)runMigration:(int)version {
    NSLog(@"Running migration %d", version);
    NSString *migrationContents = [self migrationForVersion:version];
    NSArray *migrationSteps = [migrationContents componentsSeparatedByString:@";"];
    for(NSString *step in migrationSteps) {
        NSLog(@"%@", step);
        [db executeUpdate:step];
        if ([db hadError]) {
            [NSException raise:@"Migration error" format:@"ERROR: %@", [db lastErrorMessage]];
        }
    }
    
    NSLog(@"Migrated to version %d", version);
    [self setSchemaVersion:version];
}

-(void)runMigrations {
    [db open];
    while([self schemaVersion] < [self maxMigration]) {
        NSLog(@"Current schema version: %d  (Latest: %d)", [self schemaVersion], [self maxMigration]);
        [self runMigration:[self schemaVersion] + 1];
    }
    [db close];
}

-(void)dealloc {
    if(migrationFiles) {
        [migrationFiles release];
    }
    [db release];
    [dbPath release];
    [super dealloc];
}

@end
