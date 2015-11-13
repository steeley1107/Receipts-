//
//  AddViewController.h
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@protocol AddReceiptDelegate <NSObject>

-(void)addNewReceiptWithAmount:(float)amount note:(NSString*)note date:(NSDate*)date andTagSet:(NSMutableSet*)tagSet;

@end

@interface AddViewController : UIViewController <NSFetchedResultsControllerDelegate>


@property (nonatomic, strong) id <AddReceiptDelegate> delegate;


@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end
