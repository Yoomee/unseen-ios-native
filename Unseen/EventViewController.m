//
//  EventViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation EventViewController
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize venueLabel;
@synthesize imageView;
@synthesize descriptionTextView;
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
            date = @"Wednesday 19 September 2012";
            break;
        case 2:
            date = @"Thursday 20 September 2012";
            break;
        case 3:
            date = @"Friday 21 September 2012";
            break;
        case 4:
            date = @"Saturday 22 September 2012";
            break;
        case 5:
            date = @"Sunday 23 September 2012";
            break;
        default:
            date = @"Wednesday 19 September 2012";
            break;
    }
    return date;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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
        CGRect rect = CGRectMake(0, 0, 280, 180);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *placeholder = UIGraphicsGetImageFromCurrentImageContext();
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.size.height = [event.imageHeight integerValue];
        [self.imageView setFrame:imageViewFrame];
        [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://unseenamsterdam.com%@",event.imageURL]]
                       placeholderImage:placeholder];
        [self.imageView setHidden:NO];
        descriptionTextViewOffset = [event.imageHeight integerValue] + 5;
    }
    
    CGRect frame = self.descriptionTextView.frame; 
    CGSize textSize = [event.text sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 30;
    frame.origin.y = frame.origin.y + descriptionTextViewOffset;
    [self.descriptionTextView setFrame:frame];
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 20);

}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setTimeLabel:nil];
    [self setVenueLabel:nil];
    [self setDescriptionTextView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
