//
//  PhotographersViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 24/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotographersViewController.h"
#import "PhotographerViewController.h"
#import "Photographer.h"


@implementation PhotographersViewController

@synthesize photographers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSDate *lastUpdated = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographersLastUpdatedAt"];
    if([lastUpdated timeIntervalSinceNow] < -3600.0f){
        [self loadData];
    };
    
    [self loadObjectsFromDataStore];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[[objectManager client] requestQueue] cancelRequestsWithDelegate:self];
    [objectManager.objectStore setDelegate:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photographers count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"PhotographerCell"];
    Photographer *photographer = [self.photographers objectAtIndex:indexPath.row];
    cell.textLabel.text = photographer.name;
    cell.textLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:18.0];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.129 green:0.114 blue:0.114 alpha:1.000];
    [cell setSelectedBackgroundView:backgroundView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Photographer fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name.length > 0"]];
    self.photographers = [Photographer objectsWithFetchRequest:request];
}

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/photographers" delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    // Delete any locally stored records that have been deleted on the server
    for(Photographer *photographer in [Photographer findAll]) {
        if(![objects containsObject:photographer]) {
            [[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] deleteObject:photographer];
        }
    }
    NSError *error = nil;
    if (![[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PhotographersLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self loadObjectsFromDataStore];
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    NSLog(@"Hit error: %@", error);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowPhotographer"])
	{
		PhotographerViewController *photographerViewController = segue.destinationViewController;
        NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
		photographerViewController.photographer = [self.photographers objectAtIndex:selectedPath.row];
	}
}


@end
