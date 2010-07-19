//
//  iPhone_Image_ViewerAppDelegate.m
//  iPhone Image Viewer
//
//  Created by Jason Gregori on 7/15/10.
//  Copyright MySpace, Inc. 2010. All rights reserved.
//

#import "iPhone_Image_ViewerAppDelegate.h"
#import "FilesViewController.h"


@implementation iPhone_Image_ViewerAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize filesViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	filesViewController.folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	filesViewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Copy Path"
																							 style:UIBarButtonItemStyleBordered
																							target:self
																							action:@selector(copyDocumentsPath)]
															autorelease];
    [navigationController pushViewController:filesViewController animated:NO];
    
    // Add the navigation controller's view to the window and display.
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark -
#pragma mark Open Documents Folder

- (void)copyDocumentsPath
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	[[UIPasteboard generalPasteboard] setString:path];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Documents Path Copied"
													message:@"1. Hit ⌘C to copy to your Mac's Clipboard.\n\n"
															@"2. Go to the Finder and hit ⇧⌘G (shift+command+G). A 'Go to folder' modal will pop up.\n\n"
															@"3. Paste in the documents path and hit enter.\n\n"
															@"4. Drag some images or folders into the Documents folder in the Finder. Go back to the iphone app and hit the refresh button."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end

