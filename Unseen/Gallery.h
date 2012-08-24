//
//  Gallery.h
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface Gallery : NSManagedObject{
}

@property (nonatomic, retain) NSNumber *galleryID;
@property (nonatomic, retain) NSString *name;

@end

