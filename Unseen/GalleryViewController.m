//
//  GalleryViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "GalleryViewController.h"
#import "Gallery.h"
#import "Photo.h"
#import "Photographer.h"
#import "PhotographerViewController.h"
#import "constants.h"
#import "DDPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GalleryViewController
@synthesize gallery;
@synthesize photographers;
@synthesize selectedPhotographer;
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
    
    __block float offsetX = 0;
    [gallery.photos enumerateObjectsUsingBlock:^(Photo *photo, BOOL *stop) {
        CGRect imageViewFrame = CGRectMake(offsetX + 15, 0, 290, 290);
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setFrame:imageViewFrame];
        [photosView addSubview:imageView];
        offsetX += 320;
    }];
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
    
    
    CGRect frame = galleryTextView.frame;
    frame.origin.y = offsetY;
    CGSize textSize = [gallery.text sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 50;
    [galleryTextView setFrame:frame];
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320, galleryTextView.frame.origin.y + galleryTextView.frame.size.height);
}


- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setPhotosView:nil];
    [self setRepresentedArtistsLabel:nil];
    [self setGalleryTextView:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowPhotographer"])
	{
		PhotographerViewController *photographerViewController = segue.destinationViewController;
		photographerViewController.photographer = self.selectedPhotographer;
	}
}

@end
