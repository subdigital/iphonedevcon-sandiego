//
//  FileHelpers.m
//  tailspin-iphone
//
//  Created by Ben Scheirman on 9/9/10.
//  Copyright (c) 2010 ChaiONE. All rights reserved.
//

#import "FileHelpers.h"

NSString * DocumentsDirectory() {
    NSString *docsDir = nil;
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([directories count] > 0)
        docsDir = [directories objectAtIndex:0];
    
    if(!docsDir) {
        [NSException raise:@"Critical Error" format:@"Can't find documents directory!"];
    }
    
    return docsDir;
}