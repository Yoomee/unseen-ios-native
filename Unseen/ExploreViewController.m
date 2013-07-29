//
//  ExploreViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 06/09/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "ExploreViewController.h"
#import "NewsItemViewController.h"
#import "Page.h"

@implementation ExploreViewController
@synthesize pages;

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
    
    NSDate *lastUpdated = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"PagesLastUpdatedAt"];
    if([lastUpdated timeIntervalSinceNow] < -3600.0f){
        [self loadData];
    };
    
    [self loadObjectsFromDataStore];
    
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    return pages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExploreCell"];
    Page *page = [self.pages objectAtIndex:indexPath.row];
	cell.textLabel.text = page.title;
    cell.textLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:18.0];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
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

#pragma mark - Segues


- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Page fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pageID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSString *predicateString = @"parentID == 192";
    [request setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    self.pages = [Page objectsWithFetchRequest:request];
}

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/pages" delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    for(Page *page in [Page findAll]) {
        if(![objects containsObject:page]) {
            [[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] deleteObject:page];
        }
    }
    NSError *error = nil;
    if (![[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PagesLastUpdatedAt"];
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
	if ([segue.identifier isEqualToString:@"ShowNewsItem"])
	{
		NewsItemViewController *newsItemViewController = segue.destinationViewController;
        NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
		newsItemViewController.page = [self.pages objectAtIndex:selectedPath.row];
	}
}


@end
