//
//  NewsItemViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Page;

@interface NewsItemViewController : UIViewController

@property (nonatomic, strong) Page *page;
@property (weak, nonatomic) IBOutlet UITextView *pageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *pageImage;
@property (weak, nonatomic) IBOutlet UITextView *pageText;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
- (IBAction)didPressImageButton:(id)sender;
- (IBAction)didPressShareButton:(id)sender;

@end
