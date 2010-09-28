//
//  Database.m
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/8/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"

@implementation Database

+(NSString *)databasePath {
    NSString *docsDir = nil;
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([directories count] > 0)
        docsDir = [directories objectAtIndex:0];
    
    NSString *path = [docsDir stringByAppendingPathComponent:@"/basics.db"];
    NSLog(@"DB PATH: %@", path);
    return path;
}

+(BOOL)databaseExists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[Database databasePath]];
}

+(void)createDatabase:(NSString *)creationScript {
    sqlite3 *db;
    int result = sqlite3_open([[Database databasePath] UTF8String], &db);
    if  (result != SQLITE_OK) {
        [NSException raise:@"SQLITE ERROR" format:@"Error opening the database.  The error code was %d", result];
    }
    
    char *errorMessage;
    result = sqlite3_exec(db, [creationScript UTF8String], NULL, NULL, &errorMessage);
    if (result != SQLITE_OK) {
        [NSException raise:@"SQLITE ERROR" format:@"Error executing script.  The error code was %d", result];
    }
}

int RowCallback(void * context, int numColumns, char ** columnValues, char ** columnNames) {
    
    NSLog(@"row callback!");
    NSMutableArray *results = (NSMutableArray *)context;
    NSMutableDictionary *row = [NSMutableDictionary dictionary];
    
    for (int i=0; i<numColumns; i++) {
        NSLog(@"...processing column %d", i);
        char *col = columnNames[i];
        char *value = columnValues[i];
        
        NSLog(@"column name: %s  Value:%s", col, value);
        NSString *colString = [NSString stringWithUTF8String:col];
        NSString *valueString = [NSString stringWithUTF8String:value];
        
        NSLog(@"Adding the value to the dictionary");
        [row setValue:valueString forKey:colString];
    }
    
    NSLog(@"Adding row to resultset.");
    [results addObject:row];
    
    return SQLITE_OK;
}

+(NSArray *)execute:(NSString *)sql {
    sqlite3 *db;
    sqlite3_open([[Database databasePath] UTF8String], &db);
    
    NSMutableArray *results = [[NSMutableArray array] retain];
    sqlite3_exec(db, [sql UTF8String], &RowCallback, results, NULL);
    
    NSLog(@"Done executing.  Returned %d rows.", [results count]);
    
    sqlite3_close(db);
    return results;
}

+(NSArray *)executeWithStatement:(NSString *)sql {
    sqlite3 *db;
    int result = sqlite3_open([[Database databasePath] UTF8String], &db);
    if(result != SQLITE_OK) {
        //handle error
    }
    
    sqlite3_stmt *stmt;
    result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if(result != SQLITE_OK) {
        //handle error
    }
    
    //PARAMETERS HAVE A 1-BASED INDEX!
    sqlite3_bind_int(stmt,  1 /* index */, 5 /* value */);
    sqlite3_bind_text(stmt, 2 /* index */, "some value", -1, SQLITE_TRANSIENT);
    
    result = sqlite3_step(stmt);
    if(result == SQLITE_DONE)
        return [NSArray array]; //nothing to do!
    
    NSMutableArray *results = [NSMutableArray array];
    while(result == SQLITE_ROW) {
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        
        int columnCount = sqlite3_column_count(stmt);
        for(int i=0; i<columnCount; i++) {
            const char * colName = sqlite3_column_name(stmt, i);  //0-based index!
            int type = sqlite3_column_type(stmt, i);
            id value = [NSNull null];
            if(type == SQLITE_INTEGER) {
                value = [NSNumber numberWithInt:sqlite3_column_int(stmt, i)];
            } else if (type == SQLITE_TEXT) {
                const unsigned char * text = sqlite3_column_text(stmt, i);
                value = [NSString stringWithFormat:@"%s", text];
            } else {
                // more type handling
            }
            
            [row setObject:value forKey:[NSString stringWithUTF8String:colName]];
        }
    
        [results addObject:row];
        result = sqlite3_step(stmt);
    }    
    
    return results;
}

@end


