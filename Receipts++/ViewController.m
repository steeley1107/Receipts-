//
//  ViewController.m
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//

#import "ViewController.h"
#import "Receipt.h"
#import "Tag.h"
@import CoreData;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *tagsArray;
@property (nonatomic) NSMutableArray *tagNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    fetchRequest.fetchLimit = 10;
    NSSortDescriptor *tagNames = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
    fetchRequest.sortDescriptors = @[tagNames];
    
    NSError *fetchError = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"tagName" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:&fetchError];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSUInteger count = [[self.fetchedResultsController sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    NSUInteger count = [sectionInfo numberOfObjects];
    
    Tag *tag = self.tagsArray[section];
    NSArray *receiptsArray = [tag.receipt allObjects];
    NSUInteger count01 = receiptsArray.count;
    return count01; //count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Tag *tag = self.tagsArray[indexPath.section];
    NSArray *receiptsFromTag = [tag.receipt allObjects];
    Receipt *receipt = receiptsFromTag[indexPath.row];
    
    cell.textLabel.text = receipt.note;
   // cell.detailTextLabel.text = receipt.note;
    
//    
//    Receipt *receiptObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = receiptObject.note;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.tagNames) {
        [self fetchTags];
    }
    
    if (self.tagNames.count > section) {
        
        NSString *result = [self.tagNames objectAtIndex:section];
        return result;
    }
    return nil;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addSegue"]) {
        AddViewController *addVC = (AddViewController*)[segue destinationViewController];
        addVC.delegate = self;
        addVC.context = self.context;
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}



-(void)addNewReceiptWithAmount:(float)amount note:(NSString*)note date:(NSDate*)date andTagSet:(NSMutableSet*)tagSet {
    
    Receipt *newReceiptObject = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.context];
    
    newReceiptObject.amount = amount;
    newReceiptObject.note = note;
    //   newReceiptObject.timeStamp = date;
    
    [self fetchTags];
    
    for (Tag *tag in self.tagsArray) {
        
        if ([tagSet containsObject: tag.tagName]) {
            
            [tag addReceiptObject: newReceiptObject];
        }
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}


-(void)fetchTags {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    [fetchRequest setFetchBatchSize:20];
    fetchRequest.fetchLimit = 10;
    
    NSError *fetchError = nil;
    
    self.tagNames = [[NSMutableArray alloc]init];
    self.tagsArray = [[NSArray alloc]init];
    
    self.tagsArray  = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    for (Tag *tag in self.tagsArray) {
        [self.tagNames addObject:tag.tagName];
    }
}




@end
