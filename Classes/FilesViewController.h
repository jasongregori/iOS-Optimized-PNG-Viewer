//
//  FilesViewController.h
//  iPhone Image Viewer
//
//  Created by Jason Gregori on 7/15/10.
//  Copyright 2010 MySpace, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Displays files in folder

@interface FilesViewController : UITableViewController
{
	NSString *folderPath;
	NSArray *files;
	NSMutableSet *selectedFiles;
}
// Use either folderPath or filePaths
// folderPath lists all files in that folder
@property (nonatomic, copy) NSString *folderPath;
// filePaths lists those files
@property (nonatomic, copy) NSArray *filePaths;

- (void)saveImages;
- (void)resetFolderContents;
- (NSUInteger)fileCount;
- (NSString *)fileNameAtIndex:(NSUInteger)index;
- (UIImage *)fileIconAtIndex:(NSUInteger)index;
- (void)fileAtIndexWasTapped:(NSUInteger)index;
- (BOOL)fileAtIndexIsImage:(NSUInteger)index;
- (BOOL)fileAtIndexIsFolder:(NSUInteger)index;

@end
