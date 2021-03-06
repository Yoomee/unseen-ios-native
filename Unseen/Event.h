//
//  Event.h
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Favourite;

@interface Event : NSManagedObject{
}

@property (nonatomic, retain) NSNumber *eventID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSNumber *imageHeight;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic) BOOL day1;
@property (nonatomic) BOOL day2;
@property (nonatomic) BOOL day3;
@property (nonatomic) BOOL day4;
@property (nonatomic) BOOL day5;
@property (nonatomic, retain) Favourite *favourite;


@end

