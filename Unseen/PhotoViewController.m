//
//  PhotoViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotoViewController
@synthesize photo;
@synthesize titleLabel;
@synthesize imageView;
@synthesize captionLabel;
@synthesize collectWorkButton;

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
    titleLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    titleLabel.text = photo.photographer.name;
    
    captionLabel.font = [UIFont fontWithName:@"Apercu" size:12.0];
    captionLabel.text = photo.caption;
    captionLabel.numberOfLines = 0;
    captionLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(290,9999);
    CGSize expectedLabelSize = [photo.caption sizeWithFont:captionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:captionLabel.lineBreakMode];   
    CGRect frame = captionLabel.frame;
    frame.size.height = expectedLabelSize.height;
    captionLabel.frame = frame;
    
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://unseenamsterdam.com",photo.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];

    [collectWorkButton setSelected:photo.collected];
}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setImageView:nil];
    [self setCaptionLabel:nil];
    [self setCollectWorkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didPressCollectWorkButton:(id)sender {
    if(photo.collected){
        photo.collected = NO;
    } else {
        photo.collected = YES;
    }
    [collectWorkButton setSelected:photo.collected];
    [[[RKObjectManager sharedManager] objectStore] save:nil];
}
@end