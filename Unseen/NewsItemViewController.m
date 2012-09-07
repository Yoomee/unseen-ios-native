//
//  NewsItemViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "NewsItemViewController.h"
#import "Page.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NewsItemViewController
@synthesize page;
@synthesize pageTitle;
@synthesize pageImage;
@synthesize pageText;
@synthesize imageButton;

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
    self.navigationItem.title = page.title;
    self.pageTitle.font = [UIFont fontWithName:@"Apercu-Bold" size:24.0];
    self.pageTitle.text = page.title;
    
    CGRect titleFrame = self.pageTitle.frame; 
    CGSize titleSize = [page.title sizeWithFont: [UIFont fontWithName:@"Apercu-Bold" size:24.0] constrainedToSize:CGSizeMake(titleFrame.size.width - 16, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    titleFrame.size.height = titleSize.height + 10;
    [self.pageTitle setFrame:titleFrame];
    
    NSInteger pageTextViewOffset = pageTitle.frame.origin.y + pageTitle.frame.size.height + 15;
    
    if(page.imageURL.length > 0){
        CGRect imageViewFrame = self.pageImage.frame;
        imageViewFrame.size.height = [page.imageHeight integerValue];
        imageViewFrame.origin.y = pageTextViewOffset;
        [self.pageImage setFrame:imageViewFrame];
        [self.pageImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://unseenamsterdam.com%@",page.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder-290.png"]];
        [self.pageImage setHidden:NO];
        if(page.videoURL.length > 0){
            [imageButton setFrame:imageViewFrame];
            [imageButton setHidden:NO];
        } else {
            [imageButton setHidden:YES];
        }

        pageTextViewOffset = pageTextViewOffset + [page.imageHeight integerValue] + 15;
    }
    
    [pageText setText:page.text];
    [pageText setFont:[UIFont fontWithName:@"Apercu" size:16.0]];
    CGRect frame = self.pageText.frame; 
    CGSize textSize = [page.text sizeWithFont: [UIFont fontWithName:@"Apercu" size:16.0] constrainedToSize:CGSizeMake(frame.size.width - 16, CGFLOAT_MAX)  lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = textSize.height + 10;
    frame.origin.y = pageTextViewOffset;
    [self.pageText setFrame:frame];
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(0, self.pageText.frame.origin.y + self.pageText.frame.size.height + 20);

}


- (void)viewDidUnload
{
    [self setPageTitle:nil];
    [self setPageImage:nil];
    [self setPageText:nil];
    [self setImageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didPressImageButton:(id)sender {
    if(page.videoURL.length > 0)
        NSLog(@"%@",page.videoURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: page.videoURL]]; 
}
@end
