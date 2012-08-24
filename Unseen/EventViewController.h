//
//  EventViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface EventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) Event *event;
@property (nonatomic) NSInteger selectedDay;

@end
