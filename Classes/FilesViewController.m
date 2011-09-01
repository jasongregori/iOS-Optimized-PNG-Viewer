//
//  FilesViewController.m
//  iPhone Image Viewer
//
//  Created by Jason Gregori on 7/15/10.
//  Copyright 2010 MySpace, Inc. All rights reserved.
//

#import "FilesViewController.h"

#import <pwd.h>

@interface FilesViewController ()

@property (retain, nonatomic) NSArray *files;
@property (retain, nonatomic) NSMutableIndexSet *selectedRows;
@property (readonly, nonatomic) UIBarButtonItem *saveButton;

@end

@implementation FilesViewController
@synthesize files, filePaths, folderPath, selectedRows;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedRows = [NSMutableIndexSet indexSet];
        self.toolbarItems = [NSArray arrayWithObjects:
                             [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self
                                                                            action:@selector(resetFolderContents)]
                              autorelease],
                             [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil]
                              autorelease],
                             [[[UIBarButtonItem alloc] initWithTitle:@"Toggle All"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(toggleAll)]
                              autorelease],
                             nil];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self fileCount];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
	NSString *name = [self fileNameAtIndex:indexPath.row];
	
	cell.textLabel.text = name;
	cell.imageView.image = [self fileIconAtIndex:indexPath.row];
	
	cell.accessoryType = [self.selectedRows containsIndex:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
  
  return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    if ([self fileAtIndexIsFolder:index])
	{
		FilesViewController *child = [[[FilesViewController alloc] init] autorelease];
		child.folderPath = [self.files objectAtIndex:index];
		[self.navigationController pushViewController:child animated:YES];
	}
	else
	{
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		
		if ([self.selectedRows containsIndex:index])
		{
			[self.selectedRows removeIndex:index];
			[cell setAccessoryType:UITableViewCellAccessoryNone];
			if ([self.selectedRows count] == 0)
			{
				[self.navigationItem setRightBarButtonItem:nil];
			}
		}
		else
		{
			[self.selectedRows addIndex:index];
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			[self.navigationItem setRightBarButtonItem:self.saveButton];
		}
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 1;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.folderPath = nil;
	self.selectedRows = nil;
	self.files = nil;
    self.filePaths = nil;
	
  [super dealloc];
}

#pragma mark -
#pragma mark Buttons

- (UIBarButtonItem *)saveButton
{
	return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                        target:self
                                                        action:@selector(saveImages)]
          autorelease];
}

- (void)toggleAll {
    UITableViewCellAccessoryType acc = UITableViewCellAccessoryNone;
    if ([self.selectedRows count] == [self.files count]) {
        [self.selectedRows removeAllIndexes];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        [self.selectedRows addIndexesInRange:NSMakeRange(0, self.files.count)];
        acc = UITableViewCellAccessoryCheckmark;
        [self.navigationItem setRightBarButtonItem:self.saveButton];
    }
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        cell.accessoryType = acc;
    }
}

#pragma mark -
#pragma mark File Handling

- (void)resetFolderContents
{
	if (!self.folderPath && !self.filePaths)
	{
		self.files = nil;
		[self.selectedRows removeAllIndexes];
		if (self.tableView)
		{
			[self.tableView reloadData];
		}
		return;
	}
	
	static NSArray *allowedTypes = nil;
	if (!allowedTypes)
	{
		allowedTypes = [[NSArray arrayWithObjects:@"png", @"jpg", nil] retain];
	}
	
  self.files = nil;
  
  if (self.folderPath) {
    // double check this folder exists
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.folderPath])
    {
      // TODO: set count, array, reset table view con
      NSArray *newFiles = [fm contentsOfDirectoryAtPath:self.folderPath error:NULL];
      NSMutableArray *newFilePaths = [NSMutableArray array];
      for (NSString *path in newFiles) {
        [newFilePaths addObject:[self.folderPath stringByAppendingPathComponent:path]];
      }      
      self.files = [newFilePaths objectsAtIndexes:
                    [newFilePaths indexesOfObjectsPassingTest:
                     ^(id obj, NSUInteger idx, BOOL *stop)
                     {
                       // check if it's a folder
                       BOOL isFolder;
                       if ([fm fileExistsAtPath:obj
                                    isDirectory:&isFolder] && isFolder)
                       {
                         // only return folder if there are images somewhere inside it
                         for (NSString *file in [fm enumeratorAtPath:obj]) {
                           if ([allowedTypes containsObject:[file pathExtension]]) {
                             return YES;
                           }
                         }
                         return NO;
                       }
                       // check if it's an allowed type
                       return [allowedTypes containsObject:[obj pathExtension]];
                     }]];
    }
  }
  else {
    self.files = self.filePaths;
  }
  
  if (self.files) {
		if (self.tableView)
		{
			[self.tableView reloadData];
		}
	}
	else
	{
		NSUInteger VCCount = [self.navigationController.viewControllers count];
		if (VCCount > 1)
		{
			UIViewController *parent = [self.navigationController.viewControllers objectAtIndex:(VCCount - 2)];
			if ([parent isKindOfClass:[FilesViewController class]])
			{
				[(id)parent resetFolderContents];
			}
      
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (void)setFolderPath:(NSString *)newFolderPath
{
	[folderPath autorelease];
	folderPath = [newFolderPath copy];
	
	// title
	self.navigationItem.title = [newFolderPath lastPathComponent];
	
	[self resetFolderContents];
}

- (void)setFilePaths:(NSArray *)newFilePaths
{
	[filePaths autorelease];
	filePaths = [newFilePaths copy];
	
	[self resetFolderContents];
}

- (NSUInteger)fileCount
{
	return [self.files count];
}

- (NSString *)fileNameAtIndex:(NSUInteger)index
{
	return [[self.files objectAtIndex:index] lastPathComponent];
}

- (UIImage *)fileIconAtIndex:(NSUInteger)index
{
	if ([self fileAtIndexIsFolder:index])
	{
		return [UIImage imageNamed:@"folder_icon.png"];
	}
	return [UIImage imageWithData:[NSData dataWithContentsOfFile:[self.files objectAtIndex:index]]];
}

- (BOOL)fileAtIndexIsImage:(NSUInteger)index
{
	return ![self fileAtIndexIsFolder:index];
}

- (BOOL)fileAtIndexIsFolder:(NSUInteger)index
{
	BOOL isFolder;
	return [[NSFileManager defaultManager] fileExistsAtPath:[self.files objectAtIndex:index]
                                              isDirectory:&isFolder] && isFolder;
}

- (void)saveImages
{
	NSFileManager *fm = [NSFileManager defaultManager];
  
	static NSString *saveFolder = nil;
	if (!saveFolder) {
        // get desktop
#if TARGET_IPHONE_SIMULATOR
        NSString *logname = [NSString stringWithCString:getenv("LOGNAME") encoding:NSUTF8StringEncoding];
        struct passwd *pw = getpwnam([logname UTF8String]);
        NSString *home = pw ? [NSString stringWithCString:pw->pw_dir encoding:NSUTF8StringEncoding] : [@"/Users" stringByAppendingPathComponent:logname];
        saveFolder = [NSString stringWithFormat:@"%@/Desktop", home];
#else
        saveFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
#endif
		saveFolder = [[saveFolder
                       stringByAppendingPathComponent:@"iOS Optimized PNG Viewer Saved Images"]
                      retain];
	}

    // make sure this folder exists, it could have been deleted since the last time
    if (![fm fileExistsAtPath:saveFolder])
    {
        [fm createDirectoryAtPath:saveFolder withIntermediateDirectories:NO attributes:nil error:NULL];
    }
  
	// save all selected images to save folder
	[self.selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSString *path = [self.files objectAtIndex:idx];
         
         // make sure this exists and isn't a folder
         BOOL isFolder;
         if ([fm fileExistsAtPath:path isDirectory:&isFolder] && !isFolder)
         {
             // load image
             UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
             
             // save image
             NSData *data = UIImagePNGRepresentation(image);
             [fm createFileAtPath:[saveFolder stringByAppendingPathComponent:[path lastPathComponent]]
                         contents:data
                       attributes:nil];
         }
		 
		 // uncheck image
         NSUInteger index = [self.files indexOfObject:path];
         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
         [cell setAccessoryType:UITableViewCellAccessoryNone];
	 }];
	
	[self.selectedRows removeAllIndexes];
	
	// reset right nav button
	[self.navigationItem setRightBarButtonItem:nil];
	// tell user it is finished
	self.navigationItem.prompt = @"Saved to \"Desktop\"";
	
	[self.navigationItem performSelector:@selector(setPrompt:) withObject:nil afterDelay:2];
}

@end

