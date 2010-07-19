//
//  FilesViewController.m
//  iPhone Image Viewer
//
//  Created by Jason Gregori on 7/15/10.
//  Copyright 2010 MySpace, Inc. All rights reserved.
//

#import "FilesViewController.h"

@interface FilesViewController ()

@property (retain, nonatomic) NSArray *files;
@property (retain, nonatomic) NSMutableSet *selectedFiles;
@property (readonly, nonatomic) UIBarButtonItem *saveButton;
@property (readonly, nonatomic) UIBarButtonItem *refreshButton;

@end


@implementation FilesViewController
@synthesize files, folderPath, selectedFiles;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																							target:self
																							action:@selector(resetFolderContents)]
											  autorelease];
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
	
	cell.accessoryType = [self.selectedFiles containsObject:name] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
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
	[self fileAtIndexWasTapped:indexPath.row];
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
	self.selectedFiles = nil;
	self.files = nil;
	
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

- (UIBarButtonItem *)refreshButton
{
	return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
														  target:self
														  action:@selector(resetFolderContents)]
			autorelease];
}

#pragma mark -
#pragma mark File Handling

- (void)resetFolderContents
{
	if (!self.folderPath)
	{
		self.files = nil;
		self.selectedFiles = nil;
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
	
	// double check this folder exists
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:self.folderPath])
	{
		// TODO: set count, array, reset table view con
		NSArray *newFiles = [fm contentsOfDirectoryAtPath:self.folderPath error:NULL];
		self.files = [newFiles objectsAtIndexes:
					  [newFiles indexesOfObjectsPassingTest:
					   ^(id obj, NSUInteger idx, BOOL *stop)
					   {
						   // check if it's a folder
						   BOOL isFolder;
						   if ([fm fileExistsAtPath:[self.folderPath stringByAppendingPathComponent:obj]
										isDirectory:&isFolder] && isFolder)
						   {
							   return YES;
						   }
						   // check if it's an allowed type
						   return [allowedTypes containsObject:[obj pathExtension]];
					   }]];
		self.selectedFiles = [NSMutableSet set];
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
	return [UIImage imageWithContentsOfFile:[self.folderPath stringByAppendingPathComponent:[self fileNameAtIndex:index]]];
}

- (void)fileAtIndexWasTapped:(NSUInteger)index
{
	if ([self fileAtIndexIsFolder:index])
	{
		FilesViewController *child = [[[FilesViewController alloc] init] autorelease];
		child.folderPath = [self.folderPath stringByAppendingPathComponent:[self fileNameAtIndex:index]];
		[self.navigationController pushViewController:child animated:YES];
	}
	else
	{
		NSString *path = [self fileNameAtIndex:index];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		
		if ([self.selectedFiles containsObject:path])
		{
			[self.selectedFiles removeObject:path];
			[cell setAccessoryType:UITableViewCellAccessoryNone];
			if ([self.selectedFiles count] == 0)
			{
				[self.navigationItem setRightBarButtonItem:self.refreshButton];
			}
		}
		else
		{
			[self.selectedFiles addObject:path];
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			[self.navigationItem setRightBarButtonItem:self.saveButton];
		}
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (BOOL)fileAtIndexIsImage:(NSUInteger)index
{
	return ![self fileAtIndexIsFolder:index];
}

- (BOOL)fileAtIndexIsFolder:(NSUInteger)index
{
	BOOL isFolder;
	return [[NSFileManager defaultManager] fileExistsAtPath:[self.folderPath stringByAppendingPathComponent:
															 [self fileNameAtIndex:index]]
												isDirectory:&isFolder] && isFolder;
}

- (void)saveImages
{
	NSFileManager *fm = [NSFileManager defaultManager];

	static NSString *saveFolder = nil;
	if (!saveFolder) {
		saveFolder = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
					   stringByAppendingPathComponent:@"_Saved Images"]
					  retain];
		if (![fm fileExistsAtPath:saveFolder])
		{
			[fm createDirectoryAtPath:saveFolder withIntermediateDirectories:NO attributes:nil error:NULL];
		}
	}

	// save all selected images to "Documents/_Saved Images"
	[self.selectedFiles enumerateObjectsWithOptions:NSEnumerationConcurrent
										 usingBlock:^(id obj, BOOL *stop)
	 {
		 // load image
		 UIImage *image = [UIImage imageWithContentsOfFile:[self.folderPath stringByAppendingPathComponent:obj]];
		 
		 // save image
		 NSData *data = UIImagePNGRepresentation(image);
		 [fm createFileAtPath:[saveFolder stringByAppendingPathComponent:obj]
					 contents:data
				   attributes:nil];
		 
		 // uncheck image
		 dispatch_async(dispatch_get_main_queue(), ^{
			 NSUInteger index = [self.files indexOfObject:obj];
			 UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
			 [cell setAccessoryType:UITableViewCellAccessoryNone];
		 });
	 }];
	
	[self.selectedFiles removeAllObjects];
	
	// reset refresh button
	[self.navigationItem setRightBarButtonItem:self.refreshButton];
	// tell user it is finished
	self.navigationItem.prompt = @"Saved to \"Documents/_Saved Images\"";
	
	[self.navigationItem performSelector:@selector(setPrompt:) withObject:nil afterDelay:2];
}

@end

