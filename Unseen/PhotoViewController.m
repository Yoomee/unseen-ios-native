//
//  PhotoViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import "Favourite.h"
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
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [collectWorkButton setHidden:NO];
    if(photo.favourite != nil && !photo.favourite.destroyed)
        [collectWorkButton setSelected:YES];
    else
        [collectWorkButton setSelected:NO];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"UserApiKey"] length] > 0){
        if(photo.favourite && !photo.favourite.destroyed){
            [collectWorkButton setSelected:NO];
            photo.favourite.destroyed = YES;
            photo.favourite.synced = NO;
            photo.favourite.updatedAt = [NSDate new];
            [[RKObjectManager sharedManager] deleteObject:(NSManagedObject *)[photo favourite] delegate:self];
        } else {
            [collectWorkButton setSelected:YES];
            Favourite *favourite;
            if(photo.favourite) {
                favourite = photo.favourite;
            } else {
                favourite = [Favourite object];
                favourite.photo = photo;
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

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {    
    if ([request isGET]) {  
        // Handling GET /foo.xml  
        
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isPOST]) {  
        // Handling POST /other.json
        if ([response isJSON]) {  
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
}  

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    NSLog(@"Hit error: %@", error);
}

-(void) request:(RKRequest *)request didFailLoadWithError:(NSError *)error  {
    NSLog(@"%@",error);
}
@end