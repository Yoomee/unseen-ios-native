//
//  ProfileViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "ProfileViewController.h"
#import "Photo.h"
#import "Event.h"
#import "Photographer.h"
#import "Gallery.h"
#import "Favourite.h"
#import "FavouritesSync.h"
#import "constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "EventViewController.h"
#import "PhotoViewController.h"
#import "GalleryViewController.h"
#import "PhotographerViewController.h"



@implementation ProfileViewController
@synthesize photos;
@synthesize events;
@synthesize galleries;
@synthesize photographers;
@synthesize profileImage;
@synthesize name1;
@synthesize name2;
@synthesize pageNumberLabel;
@synthesize myCollectionLabel;
@synthesize myProgrammeLabel;
@synthesize myFavouritesLabel;
@synthesize photosView;
@synthesize loggedOutOverlay;
@synthesize connectButton;
@synthesize postingFavourites;
@synthesize eventsView;
@synthesize favouritesView;
@synthesize selectedPhoto;
@synthesize selectedEvent;
@synthesize selectedGallery;
@synthesize selectedPhotographer;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    postingFavourites = NO;
}

- (void) viewWillAppear:(BOOL)animated{
    [self postFavourites];
    [super viewWillAppear:animated];
    [self renderView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[[objectManager client] requestQueue] cancelRequestsWithDelegate:self];
    [objectManager.objectStore setDelegate:nil];
}


- (void)viewDidUnload
{
    [self setPhotosView:nil];
    [self setName1:nil];
    [self setName2:nil];
    [self setProfileImage:nil];
    [self setName1:nil];
    [self setName2:nil];
    [self setLoggedOutOverlay:nil];
    [self setConnectButton:nil];
    [self setPageNumberLabel:nil];
    [self setMyCollectionLabel:nil];
    [self setMyProgrammeLabel:nil];
    [self setMyFavouritesLabel:nil];
    [self setEventsView:nil];
    [self setFavouritesView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int currentPage = floor((photosView.contentOffset.x - 320 / 2) / 320) + 2;
    [pageNumberLabel setText:[NSString stringWithFormat:@"%i of %i", currentPage, photos.count]];
}

- (IBAction)didPressConnectButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@/api/authenticate",kBaseURL ]]]; 
}

-(IBAction)showPhoto:(id)sender{
    [self setSelectedPhoto:[photos objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowPhoto" sender: self];
}

-(IBAction)showEvent:(id)sender{
    [self setSelectedEvent:[events objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowEvent" sender: self];
}

-(IBAction)showGallery:(id)sender{
    [self setSelectedGallery:[galleries objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowGallery" sender: self];
}

-(IBAction)showPhotographer:(id)sender{
    [self setSelectedPhotographer:[photographers objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowPhotographer" sender: self];
}

- (void) renderView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"UserApiKey"].length > 0) {
        [loggedOutOverlay setHidden:YES];
        self.name1.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
        self.name2.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
        
        NSString *nameLine1 = [defaults objectForKey:@"UserFirstName"];
        NSString *nameLine2 = [defaults objectForKey:@"UserLastName"];
        
        self.name1.text = nameLine1;
        self.name2.text = nameLine2;
        
        self.myCollectionLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];
        self.myProgrammeLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];
        self.myFavouritesLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];

        
        [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",[defaults objectForKey:@"UserImageURL"]]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
        
        [self loadObjectsFromDataStore];
        
        [[photosView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block float offsetX = 0;
        for (int i = 0; i < photos.count; i++) {
            Photo *photo = [photos objectAtIndex:i];
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX + 15, 0, 290, 290)];
            imageButton.tag = i;
            [imageButton addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];
            [imageView setContentMode:UIViewContentModeCenter];
            [imageView setFrame:CGRectMake(0, 0, 290, 290)];
            [imageButton addSubview:imageView];
            [photosView addSubview:imageButton];
            offsetX += 320;
        }
        photosView.contentSize = CGSizeMake(offsetX, 280);
        
        pageNumberLabel.font = [UIFont fontWithName:@"Apercu" size:12.0];
        int totalPages = photos.count;
        if (totalPages == 0)
            totalPages = 1;
        [pageNumberLabel setText:[NSString stringWithFormat:@"1 of %i", totalPages]];
        
        
        [[eventsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

        float overallOffsetY = myProgrammeLabel.frame.origin.y;
        
        if (events.count == 0){
            myProgrammeLabel.hidden = YES;
            eventsView.hidden = YES;
            
        }else {
            myProgrammeLabel.hidden = NO;
            eventsView.hidden = NO;
            __block float offsetY = 0;
            for (int i = 0; i < events.count; i++) {
                Event *event = [events objectAtIndex:i];
                UIButton *eventButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, offsetY, 322, 63)];
                [eventButton.layer setBorderWidth:1.0];
                [eventButton.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 266, 15)];
                titleLabel.text = event.title;
                titleLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:14.0];
                UILabel *venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 266, 15)];
                venueLabel.text = event.venue;
                venueLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 38, 266, 15)];
                timeLabel.text = event.time;
                timeLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
                
                UIImageView *heart = [[UIImageView alloc] initWithFrame:CGRectMake(268, 15, 36, 32)];
                [heart setContentMode:UIViewContentModeCenter];
                [heart setImage:[UIImage imageNamed:@"heart-active.png"]];
                [eventButton addTarget:self action:@selector(showEvent:) forControlEvents:UIControlEventTouchUpInside];

                eventButton.tag = i;
                [eventButton addSubview:titleLabel];
                [eventButton addSubview:venueLabel];
                [eventButton addSubview:timeLabel];
                [eventButton addSubview:heart];


                NSLog(@"Event: %@",event.title);
                [eventsView addSubview:eventButton];
                offsetY += 62;
            }
            CGRect frame = eventsView.frame;
            frame.size.height = offsetY + 1;
            [eventsView setFrame:frame];
            overallOffsetY = eventsView.frame.origin.y + eventsView.frame.size.height;
        }
        
        [[favouritesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGRect favLabelFrame = myFavouritesLabel.frame;
        favLabelFrame.origin.y = overallOffsetY + 30;
        [myFavouritesLabel setFrame:favLabelFrame];
        
        CGRect favFrame = favouritesView.frame;
        favFrame.origin.y = myFavouritesLabel.frame.origin.y + 30;
        [favouritesView setFrame:favFrame];

        if (photographers.count == 0 && galleries.count == 0){
            myFavouritesLabel.hidden = YES;
            favouritesView.hidden = YES;
            
        }else {
            myFavouritesLabel.hidden = NO;
            favouritesView.hidden = NO;
            __block float favouritesOffsetY = 0;
            for (int i = 0; i < photographers.count; i++) {
                Photographer *photographer = [photographers objectAtIndex:i];
                UIButton *photographerButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, favouritesOffsetY, 322, 66)];
                [photographerButton.layer setBorderWidth:1.0];
                [photographerButton.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, 205, 66)];
                titleLabel.text = photographer.name;
                titleLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];
                
                UIImageView *profile = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 55, 55)];
                [profile setContentMode:UIViewContentModeScaleToFill];
                
                [profile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photographer.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
                    
                
                UIImageView *heart = [[UIImageView alloc] initWithFrame:CGRectMake(268, 20, 36, 32)];
                [heart setContentMode:UIViewContentModeCenter];
                [heart setImage:[UIImage imageNamed:@"heart-active.png"]];
                [photographerButton addTarget:self action:@selector(showPhotographer:) forControlEvents:UIControlEventTouchUpInside];
                
                photographerButton.tag = i;
                [photographerButton addSubview:titleLabel];
                [photographerButton addSubview:heart];
                [photographerButton addSubview:profile];
                
                
                [favouritesView addSubview:photographerButton];
                favouritesOffsetY += 65;
            }
            for (int i = 0; i < galleries.count; i++) {
                Gallery *gallery = [galleries objectAtIndex:i];
                UIButton *galleryButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, favouritesOffsetY, 322, 66)];
                [galleryButton.layer setBorderWidth:1.0];
                [galleryButton.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:0.5] CGColor]];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, 205, 66)];
                titleLabel.text = gallery.name;
                titleLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];
                              
                UIImageView *profile = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 55, 55)];
                [profile setContentMode:UIViewContentModeScaleToFill];
                
                NSArray *galleryPhotos = [gallery.photos allObjects];
                if(galleryPhotos.count > 0){
                    Photo *photo = [galleryPhotos objectAtIndex:0];
                    [profile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];

                }
                
                UIImageView *heart = [[UIImageView alloc] initWithFrame:CGRectMake(268, 20, 36, 32)];
                [heart setContentMode:UIViewContentModeCenter];
                [heart setImage:[UIImage imageNamed:@"heart-active.png"]];
                [galleryButton addTarget:self action:@selector(showGallery:) forControlEvents:UIControlEventTouchUpInside];
                
                galleryButton.tag = i;
                [galleryButton addSubview:titleLabel];
                [galleryButton addSubview:heart];
                [galleryButton addSubview:profile];
                
                
                [favouritesView addSubview:galleryButton];
                favouritesOffsetY += 65;
            }
            CGRect favFrame = favouritesView.frame;
            favFrame.size.height = favouritesOffsetY + 1;
            [favouritesView setFrame:favFrame];
            
        }
        UIScrollView *tempScrollView = (UIScrollView *)self.view;
        tempScrollView.contentSize = CGSizeMake(320, favouritesView.frame.origin.y + favouritesView.frame.size.height + 30);
        
    } else {
        [loggedOutOverlay setHidden:NO];
        UIScrollView *tempScrollView = (UIScrollView *)self.view;
        tempScrollView.contentSize = CGSizeMake(320, 367);
    }

}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *photoRequest = [Photo fetchRequest];
    [photoRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"favourite.updatedAt" ascending:NO]]];
    [photoRequest setPredicate:[NSPredicate predicateWithFormat:@"favourite != nil AND favourite.destroyed = NO"]];
    self.photos = [Photo objectsWithFetchRequest:photoRequest];
    
    NSFetchRequest *eventRequest = [Event fetchRequest];
    [eventRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
    [eventRequest setPredicate:[NSPredicate predicateWithFormat:@"favourite != nil AND favourite.destroyed = NO"]];
    self.events = [Event objectsWithFetchRequest:eventRequest];
    
    NSFetchRequest *galleryRequest = [Gallery fetchRequest];
    [galleryRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"favourite.updatedAt" ascending:NO]]];
    [galleryRequest setPredicate:[NSPredicate predicateWithFormat:@"favourite != nil AND favourite.destroyed = NO"]];
    self.galleries = [Gallery objectsWithFetchRequest:galleryRequest];
    
    NSFetchRequest *photographerRequest = [Photographer fetchRequest];
    [photographerRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"favourite.updatedAt" ascending:NO]]];
    [photographerRequest setPredicate:[NSPredicate predicateWithFormat:@"favourite != nil AND favourite.destroyed = NO"]];
    self.photographers = [Photographer objectsWithFetchRequest:photographerRequest];
}

-(void) postFavourites{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"UserApiKey"].length > 0) {
        NSFetchRequest *request = [Favourite fetchRequest];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"synced = 0"]];
        NSArray *favourites = [Favourite objectsWithFetchRequest:request];
        
        if(favourites.count > 0){
            FavouritesSync *favouritesSync = [[FavouritesSync alloc] init];
            [favouritesSync setFavourites:favourites];
            
            RKObjectManager *objectManager = [RKObjectManager sharedManager];
            postingFavourites = YES;
            [objectManager postObject:favouritesSync delegate:self];
            
        } else{
            [self loadData];
        }
    }
}

- (void)loadData
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/favourites" delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if(postingFavourites){
        postingFavourites = NO;
        [self loadData];
    } else {
        NSFetchRequest *request = [Favourite fetchRequest];
        NSArray *favourites = [Favourite objectsWithFetchRequest:request];
        for(Favourite *favourite in favourites){
            if(![objects containsObject:favourite] || ([favourite.favouriteID intValue] == 0)) {
                [[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] deleteObject:favourite];
            }
        }
        NSError *error = nil;
        if (![[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"FavouritesLastUpdatedAt"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self loadObjectsFromDataStore];
        [self renderView];
    }
    
    
//    // Delete any locally stored records that have been deleted on the server
//    for(Photographer *photographer in [Photographer findAll]) {
//        if(![objects containsObject:photographer]) {
//            [[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] deleteObject:photographer];
//        }
//    }
//    NSError *error = nil;
//    if (![[[[RKObjectManager sharedManager] objectStore] managedObjectContextForCurrentThread] save:&error]){
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"PhotographersLastUpdatedAt"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    
//    [self loadObjectsFromDataStore];
//    [self.tableView reloadData];

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    if(postingFavourites && error.code == 1001){
        postingFavourites = NO;
        [self loadData];
    }
    NSLog(@"Hit error: %@", error);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowEvent"])
	{
		EventViewController *eventViewController = segue.destinationViewController;
		eventViewController.event = selectedEvent;
	} else if ([segue.identifier isEqualToString:@"ShowPhoto"]){
        PhotoViewController *photoViewController = segue.destinationViewController;
		photoViewController.photo = selectedPhoto;
    } else if ([segue.identifier isEqualToString:@"ShowGallery"]){
        GalleryViewController *galleryViewController = segue.destinationViewController;
		galleryViewController.gallery = selectedGallery;
    } else if ([segue.identifier isEqualToString:@"ShowPhotographer"]){
        PhotographerViewController *photographerViewController = segue.destinationViewController;
		photographerViewController.photographer = selectedPhotographer;
    }
}

@end
