//
//  ProgrammeViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "ProgrammeViewController.h"
#import "EventViewController.h"
#import "Event.h"
#import "Favourite.h"

@implementation ProgrammeViewController
@synthesize tableView;
@synthesize daySelectorsView;
@synthesize events;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
    
    
    NSDate *lastUpdated = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ProgrammeLastUpdatedAt"];
    if([lastUpdated timeIntervalSinceNow] < -3600.0f){
        [self loadData];
    };

    [self loadObjectsFromDataStoreForDay:1];
    
    for(UIButton *button in [self.daySelectorsView subviews]){
        [button.titleLabel setFont:[UIFont fontWithName:@"Apercu-Bold" size:12.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.129 green:0.114 blue:0.114 alpha:1.000]];
        CGRect rect = CGRectMake(0, 0, 64, 44);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [button setBackgroundImage:img forState:UIControlStateHighlighted];
        [button setBackgroundImage:img forState:UIControlStateSelected];
    };
    
    [[self.daySelectorsView.subviews objectAtIndex:0] setSelected:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDaySelectorsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated  
{  
    [super viewWillAppear:animated];
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];  
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    [self.tableView reloadData];
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"ProgrammeCell"];
    Event *event = [self.events objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
	titleLabel.text = event.title;
    titleLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:14.0];
    UILabel *venueLabel = (UILabel *)[cell viewWithTag:2];
	venueLabel.text = event.venue;
    venueLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:3];
	timeLabel.text = event.time;
    timeLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.129 green:0.114 blue:0.114 alpha:1.000];
    [cell setSelectedBackgroundView:backgroundView];
    
    UIImageView *heart = (UIImageView *)[cell viewWithTag:4];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"UserApiKey"] length] > 0){
        [heart setHidden:NO];
        if(event.favourite != nil && !event.favourite.destroyed)
            [heart setImage:[UIImage imageNamed:@"heart-active.png"]];
        else
            [heart setImage:[UIImage imageNamed:@"heart.png"]];
    } else {
        [heart setHidden:YES];        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowEvent"])
	{
		EventViewController *eventViewController = segue.destinationViewController;
        NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
		eventViewController.event = [self.events objectAtIndex:selectedPath.row];
        eventViewController.selectedDay = [self selectedDay];
	}
}

- (void)loadObjectsFromDataStoreForDay:(NSInteger)day
{
    NSFetchRequest *request = [Event fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSString *predicateString = [NSString stringWithFormat:@"day%i == YES", day];
    [request setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    self.events = [Event objectsWithFetchRequest:request];
}

- (IBAction)didPressDaySelector:(id)sender {
    for(UIButton *button in [self.daySelectorsView subviews]){
        if(button.tag == [sender tag]){
            [button setSelected:YES];
        } else {
            [button setSelected:NO];            
        }
    };
    [self loadObjectsFromDataStoreForDay:[sender tag] + 1];
    [self.tableView reloadData];
}

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/events" delegate:self];
}

-(NSInteger)selectedDay {
    NSInteger day = 0;
    for(UIButton *button in [self.daySelectorsView subviews]){
        if([button isSelected]){
            day = [button tag] + 1;
        }
    };
    return day;
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"ProgrammeLastUpdatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadObjectsFromDataStoreForDay:[self selectedDay]];
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    NSLog(@"Hit error: %@", error);
}



@end
