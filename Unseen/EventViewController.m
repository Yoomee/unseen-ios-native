//
//  EventViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import "Favourite.h"
#import "constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SHK.h"

@implementation EventViewController
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize venueLabel;
@synthesize imageView;
@synthesize descriptionTextView;
@synthesize favouriteButton;
@synthesize selectedDay;
@synthesize event, titleLabel;

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

-(NSString *)selectedDate{
    NSString *date;
    switch (selectedDay)
    {
        case 1:
            date = @"Thursday 18 September 2014";
            break;
        case 2:
            date = @"Friday 19 September 2014";
            break;
        case 3:
            date = @"Saturday 20 September 2014";
            break;
        case 4:
            date = @"Sunday 21 September 2014";
            break;
        default:
            date = @"Thursday 18 September 2014";
            break;
    }
    return date;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = event.title;
    
    self.titleLabel.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    self.dateLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
    self.timeLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
    self.venueLabel.font = [UIFont fontWithName:@"Apercu" size:14.0];
    self.descriptionTextView.font = [UIFont fontWithName:@"Apercu" size:16.0];
    
    self.titleLabel.text = event.title;
    self.dateLabel.text = [self selectedDate];
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",event.time];
    self.venueLabel.text = [NSString stringWithFormat:@"Venue: %@",event.venue];
    self.descriptionTextView.text = event.text;
    
    NSInteger descriptionTextViewOffset = 0;
    
    if(event.imageURL.length > 0){
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.size.height = [event.imageHeight integerValue];
        [self.imageView setFrame:imageViewFrame];
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,event.imageURL]]
                       placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];
        [self.imageView setHidden:NO];
        descriptionTextViewOffset = [event.imageHeight integerValue] + 5;
    }
    
    CGRect frame = self.descriptionTextView.frame; 
    CGSize textSize = [event.text sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width - 16, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 15;
    frame.origin.y = frame.origin.y + descriptionTextViewOffset;
    [self.descriptionTextView setFrame:frame];
    
    CGRect buttonFrame = favouriteButton.frame;
    buttonFrame.origin.y = descriptionTextView.frame.origin.y + descriptionTextView.frame.size.height + 20;
    [favouriteButton setFrame:buttonFrame];
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320, favouriteButton.frame.origin.y + favouriteButton.frame.size.height + 30);

}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setTimeLabel:nil];
    [self setVenueLabel:nil];
    [self setDescriptionTextView:nil];
    [self setImageView:nil];
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


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [favouriteButton setHidden:NO];
    if(event.favourite != nil && !event.favourite.destroyed)
        [favouriteButton setSelected:YES];
    else
        [favouriteButton setSelected:NO];
}

- (IBAction)didPressFavouriteButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"UserApiKey"] length] > 0){
        if(event.favourite && !event.favourite.destroyed){
            [favouriteButton setSelected:NO];
            event.favourite.destroyed = YES;
            event.favourite.synced = NO;
            event.favourite.updatedAt = [NSDate new];
            [[RKObjectManager sharedManager] deleteObject:(NSManagedObject *)[event favourite] delegate:self];
        } else {
            [favouriteButton setSelected:YES];
            Favourite *favourite;
            if(event.favourite) {
                favourite = event.favourite;
            } else {
                favourite = [Favourite object];
                favourite.event = event;
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/events/%@",kBaseURL,event.eventID]];
    SHKItem *item = [SHKItem URL:url title:[NSString stringWithFormat:@"Unseen Photo Fair Amsterdam - %@", event.title] contentType:SHKURLContentTypeWebpage];
    item.facebookURLSharePictureURI = [NSString stringWithFormat:@"%@%@",kBaseURL,event.imageURL];
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
