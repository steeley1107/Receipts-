//
//  ViewController.h
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddViewController.h"

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate, AddReceiptDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

