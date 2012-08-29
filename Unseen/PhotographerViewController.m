//
//  PhotographerViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 28/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotographerViewController.h"
#import "Photo.h"
#import "Gallery.h"
#import "constants.h"
#import "DDPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotographerViewController
@synthesize photographer;
@synthesize profileImage;
@synthesize name1;
@synthesize name2;
@synthesize galleryLabel;
@synthesize photosView;
@synthesize bioTextView;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name1.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    self.name2.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    self.galleryLabel.font = [UIFont fontWithName:@"Apercu" size:12.0];
    
    NSArray *nameParts = [photographer.name componentsSeparatedByString:@" "];
    NSString *nameLine1 = [NSString stringWithFormat:@""];
    NSString *nameLine2 = [NSString stringWithFormat:@""];
    int line1 = 0;
    for (int i=0; i < nameParts.count; i++) {
        NSString *word = (NSString *)[nameParts objectAtIndex:i];
        line1 += word.length;
        if(line1 < 15){
            nameLine1 = [NSString stringWithFormat:@"%@%@ ",nameLine1,word];
        } else {
            nameLine2 = [NSString stringWithFormat:@"%@%@ ",nameLine2,word];
        }
    }
    self.name1.text = nameLine1;
    self.name2.text = nameLine2;
    
    
    if([nameLine2 isEqualToString:@""]){
        CGRect frame = self.galleryLabel.frame; 
        frame.origin.y = 38;
        [self.galleryLabel setFrame:frame]; 
    }
    
    NSArray *galleries = [[NSArray alloc] initWithArray:[photographer.galleries allObjects]];
    self.galleryLabel.text = [[galleries objectAtIndex:0] name];
    
    self.bioTextView.text = photographer.bio;
    self.bioTextView.font = [UIFont fontWithName:@"Apercu" size:16.0];
    
    CGRect frame = self.bioTextView.frame; 
    CGSize textSize = [photographer.bio sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 50;
    [self.bioTextView setFrame:frame];
    
    [profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photographer.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-55.png"]];
    
    pageControl = [[DDPageControl alloc] init];
	[pageControl setCenter: CGPointMake(160.0f, 400.0f)] ;
    pageControl.numberOfPages = [photographer.photos count];
    pageControl.currentPage = 0;
    [pageControl setDefersCurrentPageDisplay: YES] ;
    [pageControl setHidesForSinglePage:YES];
	[pageControl setType: DDPageControlTypeOnFullOffFull];
	[pageControl setOnColor: [UIColor colorWithWhite: 0.0f alpha: 1.0f]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.8f alpha: 1.0f]] ;
    [self.view addSubview:pageControl];
    
    __block float offsetX = 15;
    [photographer.photos enumerateObjectsUsingBlock:^(Photo *photo, BOOL *stop) {
        CGRect imageViewFrame = CGRectMake(offsetX, 0, 290, 290);
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setFrame:imageViewFrame];
        [photosView addSubview:imageView];
        offsetX += 320;
    }];
    photosView.contentSize = CGSizeMake(offsetX, 280);
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320, bioTextView.frame.origin.y + bioTextView.frame.size.height + 60);
}


- (void)viewDidUnload
{
    [self setPhotosView:nil];
    [self setName1:nil];
    [self setName2:nil];
    [self setProfileImage:nil];
    [self setBioTextView:nil];
    [self setName1:nil];
    [self setName2:nil];
    [self setGalleryLabel:nil];
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

@end
