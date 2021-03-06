//
//  Favourite.h
//  Unseen
//
//  Created by Matthew Atkins on 31/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Photo, Photographer, Gallery, Event;

@interface Favourite : NSManagedObject {
}

@property (nonatomic, retain) NSNumber * favouriteID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Gallery *gallery;
@property (nonatomic, retain) Photographer *photographer;
@property (nonatomic, retain) Event *event;
@property (nonatomic) BOOL destroyed;
@property (nonatomic) BOOL synced;

@end
