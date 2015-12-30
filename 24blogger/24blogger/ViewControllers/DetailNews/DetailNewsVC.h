//
//  DetailNewsVC.h
//  24blogger
//
//  Created by iZaVyLoN on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailNewsVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *detailNewsTableView;
@property (nonatomic, strong) NSString *titleNews;
@property (nonatomic, strong) NSArray *arrayFavorites;
@property (nonatomic, assign) NSInteger newsID;

@property (nonatomic, strong) NSString *slugPost;

@end
