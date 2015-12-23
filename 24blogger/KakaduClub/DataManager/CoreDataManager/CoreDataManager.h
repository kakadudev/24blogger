//
//  CoreDataManager
//  KakaduClub
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)sharedManager;
- (void)saveContext;

@end
