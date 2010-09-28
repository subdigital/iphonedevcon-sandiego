//
//  hello_devconAppDelegate.h
//  hello-devcon
//
//  Created by Ben Scheirman on 9/28/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hello_devconAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end

