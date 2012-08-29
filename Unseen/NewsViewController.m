//
//  NewsViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsItemViewController.h"
#import "Page.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NewsViewController
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

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NewsItemCell"];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    Page *page = [self.pages objectAtIndex:indexPath.row];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",page.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
    
    UILabel *titleLabel1 = (UILabel *)[cell viewWithTag:2];
    UILabel *titleLabel2 = (UILabel *)[cell viewWithTag:3];

    titleLabel1.font = [UIFont fontWithName:@"Apercu" size:18.0];
    titleLabel2.font = [UIFont fontWithName:@"Apercu" size:18.0];

    NSArray *titleParts = [page.title componentsSeparatedByString:@" "];
    NSString *title1 = [NSString stringWithFormat:@""];
    NSString *title2 = [NSString stringWithFormat:@""];
    int line1 = 0;
    for (int i=0; i < titleParts.count; i++) {
        NSString *word = (NSString *)[titleParts objectAtIndex:i];
        line1 += word.length;
        if(line1 < 20){
            title1 = [NSString stringWithFormat:@"%@%@ ",title1,word];
        } else {
            title2 = [NSString stringWithFormat:@"%@%@ ",title2,word];
        }
    }
    titleLabel1.text = title1;
    titleLabel2.text = title2;
//    if([titleLabel2.text isEqualToString:@""]){
//        CGRect frame = titleLabel1.frame;
//        frame.size.height = 55.0f;
//        titleLabel1.frame = frame;
//    }
    
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
    NSFetchRequest *request = [Page fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"publicationDate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
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
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PagesLastUpdatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
