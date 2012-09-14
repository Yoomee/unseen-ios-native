//
//  GalleryViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "GalleryViewController.h"
#import "Gallery.h"
#import "Favourite.h"
#import "Photo.h"
#import "Photographer.h"
#import "PhotographerViewController.h"
#import "PhotoViewController.h"
#import "constants.h"
#import "DDPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SHK.h"

@implementation GalleryViewController
@synthesize favouriteButton;
@synthesize gallery;
@synthesize photographers;
@synthesize photos;
@synthesize selectedPhotographer;
@synthesize selectedPhoto;
@synthesize nameLabel;
@synthesize representedArtistsLabel;
@synthesize photosView;
@synthesize galleryTextView;

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
    self.navigationItem.title = gallery.name;

    self.nameLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    self.nameLabel.text = gallery.name;
    
    self.representedArtistsLabel.font = [UIFont fontWithName:@"Apercu" size:16.0];
    
    self.galleryTextView.text = [gallery.text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    self.galleryTextView.font = [UIFont fontWithName:@"Apercu" size:16.0];
    
    
    pageControl = [[DDPageControl alloc] init];
	[pageControl setCenter: CGPointMake(160.0f, 400.0f)] ;
    pageControl.numberOfPages = [gallery.photos count];
    pageControl.currentPage = 0;
    [pageControl setDefersCurrentPageDisplay: YES] ;
    [pageControl setHidesForSinglePage:YES];
	[pageControl setType: DDPageControlTypeOnFullOffFull];
	[pageControl setOnColor: [UIColor colorWithWhite: 0.0f alpha: 1.0f]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.8f alpha: 1.0f]] ;
    [self.view addSubview:pageControl];
    
    self.photos = [[NSArray alloc] initWithArray:[gallery.photos allObjects]];

    
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
    
    self.photographers = [[NSArray alloc] initWithArray:[gallery.photographers allObjects]];
    __block float offsetY = representedArtistsLabel.frame.origin.y + 30;
    for (int i = 0; i < photographers.count; i++) 
    {
        Photographer *photographer = [photographers objectAtIndex:i];
        CGRect viewFrame = CGRectMake(15, offsetY, 290, 55);
        UIButton *representedArtistView = [[UIButton alloc] initWithFrame:viewFrame];
        representedArtistView.tag = i;
        [representedArtistView addTarget:self action:@selector(showPhotographer:) forControlEvents:UIControlEventTouchDown];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photographer.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setFrame:CGRectMake(0, 0, 55, 55)];
        UILabel *artistName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 220, 55)];
        [artistName setNumberOfLines:2];
        artistName.text = photographer.name;
        artistName.font = [UIFont fontWithName:@"Apercu" size:16.0];
        [representedArtistView addSubview:imageView];
        [representedArtistView addSubview:artistName];
        [self.view addSubview:representedArtistView];
        offsetY += 65;
    }
    
    self.selectedPhotographer = nil;
    self.selectedPhoto = nil;
    
    
    CGRect frame = galleryTextView.frame;
    frame.origin.y = offsetY;
    CGSize textSize = [gallery.text sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width - 16, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 10;
    [galleryTextView setFrame:frame];
    
    CGRect buttonFrame = favouriteButton.frame;
    buttonFrame.origin.y = galleryTextView.frame.origin.y + galleryTextView.frame.size.height + 20;
    [favouriteButton setFrame:buttonFrame];
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320, favouriteButton.frame.origin.y + favouriteButton.frame.size.height + 30);
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setPhotosView:nil];
    [self setRepresentedArtistsLabel:nil];
    [self setGalleryTextView:nil];
    [self setFavouriteButton:nil];
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
    pageControl.currentPage = floor((photosView.contentOffset.x - 280 / 2) / 280) + 1;
    [pageControl updateCurrentPageDisplay];
}

- (IBAction)showPhotographer:(id)sender {
    [self setSelectedPhotographer:[photographers objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowPhotographer" sender: self];
}

- (IBAction)showPhoto:(id)sender {
    [self setSelectedPhoto:[photos objectAtIndex:[sender tag]]];
    [self performSegueWithIdentifier: @"ShowPhoto" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowPhotographer"])
	{
		PhotographerViewController *photographerViewController = segue.destinationViewController;
		photographerViewController.photographer = self.selectedPhotographer;
	} else if ([segue.identifier isEqualToString:@"ShowPhoto"])
	{
		PhotoViewController *photoViewController = segue.destinationViewController;
		photoViewController.photo = self.selectedPhoto;
	}
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [favouriteButton setHidden:NO];
    if(gallery.favourite != nil && !gallery.favourite.destroyed)
        [favouriteButton setSelected:YES];
    else
        [favouriteButton setSelected:NO];
    
}

- (IBAction)didPressFavouriteButton:(id)sender {    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"UserApiKey"] length] > 0){
        if(gallery.favourite && !gallery.favourite.destroyed){
            [favouriteButton setSelected:NO];
            gallery.favourite.destroyed = YES;
            gallery.favourite.synced = NO;
            gallery.favourite.updatedAt = [NSDate new];
            [[RKObjectManager sharedManager] deleteObject:(NSManagedObject *)[gallery favourite] delegate:self];
        } else {
            [favouriteButton setSelected:YES];
            Favourite *favourite;
            if(gallery.favourite) {
                favourite = gallery.favourite;
            } else {
                favourite = [Favourite object];
                favourite.gallery = gallery;
            }
            favourite.destroyed = NO;
            favourite.synced = NO;
            favourite.updatedAt = [NSDate new];
            [[RKObjectManager sharedManager] postObject:favourite delegate:self];
        }
        [[[RKObjectManager sharedManager] objectStore] save:nil];
    } else {
        [self.tabBarController setSelectedIndex:3];
    }
}

- (IBAction)didPressShareButton:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/galleries/%@",kBaseURL,gallery.galleryID]];
    SHKItem *item = [SHKItem URL:url title:[NSString stringWithFormat:@"Unseen Photo Fair Amsterdam - %@", gallery.name] contentType:SHKURLContentTypeWebpage];
    if(photos.count > 0){
        item.facebookURLSharePictureURI = [NSString stringWithFormat:@"%@%@",kBaseURL,[(Photo *)[photos objectAtIndex:0] imageURL]];

    }
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {    
}  

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Hit error: %@", error);
}

-(void) request:(RKRequest *)request didFailLoadWithError:(NSError *)error  {
    NSLog(@"%@",error);
}

@end
