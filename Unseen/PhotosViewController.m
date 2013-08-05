//
//  PhotosViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoViewController.h"
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotosViewController
@synthesize photosView;
@synthesize pageNumberLabel;
@synthesize photos;
@synthesize numberOfPages;
@synthesize selectedPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *lastUpdated = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"PhotosLastUpdatedAt"];
    if([lastUpdated timeIntervalSinceNow] < -3600.0f){
        [self loadData];
    };
    
    [self loadObjectsFromDataStore];
    pageNumberLabel.font = [UIFont fontWithName:@"Apercu" size:12.0];
    
    if (IS_IPHONE_5) {
        for(UIView *subview in self.view.subviews){
            CGRect frame = subview.frame;            
            frame.origin.y = (455.0/2)-(1.1217 * ((367.0/2)-(frame.origin.y + frame.size.height/2)) - 8.47) - frame.size.height/2;
            NSLog(@"After: %f", frame.origin.y);
            subview.frame = frame;
        }
    }
    
    [self layoutPhotos];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload
{
    [self setPhotosView:nil];
    [self setPageNumberLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[[objectManager client] requestQueue] cancelRequestsWithDelegate:self];
    [objectManager.objectStore setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Photo fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"photoID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    self.photos = [Photo objectsWithFetchRequest:request];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int currentPage = floor((photosView.contentOffset.x - 320 / 2) / 320) + 2;
    [pageNumberLabel setText:[NSString stringWithFormat:@"%i of %i", currentPage, numberOfPages]];
}

- (IBAction)showPhoto:(id)sender {
    [self setSelectedPhoto:[photos objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowPhoto" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowPhoto"])
	{
		PhotoViewController *photoViewController = segue.destinationViewController;
		photoViewController.photo = self.selectedPhoto;
	}
}

- (void) layoutPhotos
{
    self.selectedPhoto = nil;
    
    [photosView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UIView *pageWrapper;
    for(int i = 0; i < photos.count; i++){
        if (i % 4 == 0)
            pageWrapper = [[UIView alloc] initWithFrame:CGRectMake(((i / 4) * 320), 0, 320, 280)];
        Photo *photo = [photos objectAtIndex:i];
        int col = ((i % 4)/2);
        int row = (i % 2);
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake((col * 130) + ((col + 1) * 20), (row  * 150), 130, 130)];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-130.png"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setFrame:CGRectMake(0,0,130,130)];
        [imageButton addSubview:imageView];
        [pageWrapper addSubview:imageButton];
        if ((i % 4 == 3) || (i == (photos.count - 1))) {
            [photosView addSubview:pageWrapper];
        }
    }
    int pages = (photos.count / 4);
    if(photos.count % 4 > 0 ){
        pages++;
    }
    self.numberOfPages = pages;
    photosView.contentSize = CGSizeMake((numberOfPages * 320), 280);
    pageNumberLabel.font = [UIFont fontWithName:@"Apercu" size:12.0];
    [pageNumberLabel setText:[NSString stringWithFormat:@"1 of %i", numberOfPages]];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)loadData
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/photos" delegate:self];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    // Delete any locally stored records that have been deleted on the server
    for(Photo *photo in [Photo findAll]) {
        if(![objects containsObject:photo]) {
            [[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] deleteObject:photo];
        }
    }
    NSError *error = nil;
    if (![[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PhotosLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self loadObjectsFromDataStore];
    [self layoutPhotos];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    NSLog(@"Hit error: %@", error);
}

@end
