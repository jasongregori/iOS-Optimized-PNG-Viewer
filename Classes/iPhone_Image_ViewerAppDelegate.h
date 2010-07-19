//
//  iPhone_Image_ViewerAppDelegate.h
//  iPhone Image Viewer
//
//  Created by Jason Gregori on 7/15/10.
//  Copyright MySpace, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilesViewController.h"

@interface iPhone_Image_ViewerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	FilesViewController *filesViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet FilesViewController *filesViewController;


- (void)copyDocumentsPath;

@end

