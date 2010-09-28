//
//  Database.h
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/8/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Database : NSObject {
    
}

+(NSString *)databasePath;
+(BOOL)databaseExists;
+(void)createDatabase:(NSString *)creationScript;
+(NSArray *)execute:(NSString *)sql;

@end
