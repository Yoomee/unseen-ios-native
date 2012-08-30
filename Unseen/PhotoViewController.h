//
//  PhotoViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photographer.h"

@class Photo;

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) Photo *photo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectWorkButton;
- (IBAction)didPressCollectWorkButton:(id)sender;

@end
