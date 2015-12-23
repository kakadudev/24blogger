//
//  Feed+CoreDataProperties.h
//  
//
//  Created by iZaVyLoN on 11/29/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorText;
@property (nullable, nonatomic, retain) NSString *dateText;
@property (nullable, nonatomic, retain) NSString *descriptionText;
@property (nullable, nonatomic, retain) NSNumber *heightMainImage;
@property (nullable, nonatomic, retain) NSNumber *feedId;
@property (nullable, nonatomic, retain) NSString *slugPost;
@property (nullable, nonatomic, retain) NSString *titleText;
@property (nullable, nonatomic, retain) NSString *urlMainImage;
@property (nullable, nonatomic, retain) NSNumber *widthMainImage;

@end

NS_ASSUME_NONNULL_END
