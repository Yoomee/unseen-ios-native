//
//  ProfileViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "ProfileViewController.h"
#import "Photo.h"
#import "Favourite.h"
#import "FavouritesSync.h"
#import "constants.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation ProfileViewController
@synthesize photos;
@synthesize profileImage;
@synthesize name1;
@synthesize name2;
@synthesize pageNumberLabel;
@synthesize myCollectionLabel;
@synthesize photosView;
@synthesize loggedOutOverlay;
@synthesize connectButton;
@synthesize postingFavourites;

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    postingFavourites = NO;
}

- (void) viewWillAppear:(BOOL)animated{
    [self postFavourites];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self renderView];
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
        
        [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",[defaults objectForKey:@"UserImageURL"]]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
        
        //UIScrollView *tempScrollView = (UIScrollView *)self.view;
        //tempScrollView.contentSize = CGSizeMake(320, 1000);
        
        [self loadObjectsFromDataStore];
        
        [[photosView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block float offsetX = 0;
        for (int i = 0; i < photos.count; i++) {
            Photo *photo = [photos objectAtIndex:i];
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX + 15, 0, 290, 290)];
            imageButton.tag = i;
            //[imageButton addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
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
        [pageNumberLabel setText:[NSString stringWithFormat:@"1 of %i", photos.count]];
    } else {
        [loggedOutOverlay setHidden:NO];
        UIScrollView *tempScrollView = (UIScrollView *)self.view;
        tempScrollView.contentSize = CGSizeMake(320, 367);
    }

}

- (void)loadObjectsFromDataStore
{
    NSFetchRequest *request = [Photo fetchRequest];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite.updatedAt" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"favourite != nil AND favourite.destroyed = NO"]];
    self.photos = [Photo objectsWithFetchRequest:request];
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
        [request setPredicate:[NSPredicate predicateWithFormat:@"favouriteID = 0"]];
        NSArray *favourites = [Favourite objectsWithFetchRequest:request];
        for(int i = 0; i< favourites.count; i++){
            Favourite *favourite = [favourites objectAtIndex:i];
            RKObjectManager *objectManager = [RKObjectManager sharedManager];
            [[objectManager.objectStore managedObjectContextForCurrentThread] deleteObject:favourite];
        }
        [[[RKObjectManager sharedManager] objectStore] save:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"FavouritesLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadObjectsFromDataStore];
        [self renderView];
    }

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

@end
