//
//  sqlite_basicsViewController.h
//  sqlite_basics
//
//  Created by Ben Scheirman on 9/8/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sqlite_basicsViewController : UIViewController {
    UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)insertSomeData:(id)sender;
- (IBAction)queryTheTable:(id)sender;
@end

