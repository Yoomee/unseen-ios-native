//
//  AppDelegate.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "AppDelegate.h"
#import "constants.h"
#import "Event.h"
#import "Gallery.h"
#import "Photographer.h"
#import "Photo.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Load default defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Override point for customization after application launch.
    // Initialize RestKit
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:[NSString stringWithFormat:@"%@/api/2", kBaseURL]];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Initialize object store
    NSString *seedDatabaseName = @"UnseenSeed.sqlite";
    NSString *databaseName = @"Unseen.sqlite";
    
    //objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName usingSeedDatabaseName:seedDatabaseName managedObjectModel:nil delegate:self];
    objectManager.objectStore =[RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    
    // Setup our object mappings
    /*!
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    
    RKManagedObjectMapping* eventMapping = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:objectManager.objectStore];
    eventMapping.primaryKeyAttribute = @"eventID";
    [eventMapping mapKeyPath:@"id" toAttribute:@"eventID"];
    [eventMapping mapKeyPath:@"title" toAttribute:@"title"];
    [eventMapping mapKeyPath:@"description" toAttribute:@"text"];
    [eventMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [eventMapping mapKeyPath:@"image_height_for_api" toAttribute:@"imageHeight"];
    [eventMapping mapKeyPath:@"venue_name" toAttribute:@"venue"];
    [eventMapping mapKeyPath:@"time_string" toAttribute:@"time"];
    [eventMapping mapKeyPath:@"day1" toAttribute:@"day1"];
    [eventMapping mapKeyPath:@"day2" toAttribute:@"day2"];
    [eventMapping mapKeyPath:@"day3" toAttribute:@"day3"];
    [eventMapping mapKeyPath:@"day4" toAttribute:@"day4"];
    [eventMapping mapKeyPath:@"day5" toAttribute:@"day5"];    
    [objectManager.mappingProvider setObjectMapping:eventMapping forResourcePathPattern:@"/events"];
    
    RKManagedObjectMapping* galleryMapping = [RKManagedObjectMapping mappingForClass:[Gallery class] inManagedObjectStore:objectManager.objectStore];
    galleryMapping.primaryKeyAttribute = @"galleryID";
    [galleryMapping mapKeyPath:@"id" toAttribute:@"galleryID"];
    [galleryMapping mapKeyPath:@"title" toAttribute:@"name"];
    [galleryMapping mapKeyPath:@"contact_details" toAttribute:@"text"];
    [objectManager.mappingProvider setObjectMapping:galleryMapping forResourcePathPattern:@"/galleries"];
    
    RKManagedObjectMapping* photographerMapping = [RKManagedObjectMapping mappingForClass:[Photographer class] inManagedObjectStore:objectManager.objectStore];
    photographerMapping.primaryKeyAttribute = @"photographerID";
    [photographerMapping mapKeyPath:@"id" toAttribute:@"photographerID"];
    [photographerMapping mapKeyPath:@"full_name" toAttribute:@"name"];
    [photographerMapping mapKeyPath:@"bio" toAttribute:@"bio"];
    [photographerMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [objectManager.mappingProvider setObjectMapping:photographerMapping forResourcePathPattern:@"/photographers"];
    
    RKManagedObjectMapping *photoMapping = [RKManagedObjectMapping mappingForClass:[Photo class] inManagedObjectStore:objectManager.objectStore];
    photoMapping.primaryKeyAttribute = @"photoID";
    [photoMapping mapKeyPath:@"id" toAttribute:@"photoID"];
    [photoMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [photoMapping mapKeyPath:@"caption" toAttribute:@"caption"];

    [photoMapping mapRelationship:@"photographer" withMapping:photographerMapping];
    [photoMapping mapRelationship:@"galleries" withMapping:galleryMapping];
    
    [photographerMapping mapRelationship:@"galleries" withMapping:galleryMapping];
    [photographerMapping mapRelationship:@"photos" withMapping:photoMapping];
    
    [galleryMapping mapRelationship:@"photographers" withMapping:photographerMapping];
    [galleryMapping mapRelationship:@"photos" withMapping:photoMapping];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
