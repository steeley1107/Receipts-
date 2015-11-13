//
//  AddViewController.m
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//

#import "AddViewController.h"
#import "Tag.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableSet *tagSelectedSet;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    fetchRequest.fetchLimit = 10;
    NSSortDescriptor *tagTitle = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
    fetchRequest.sortDescriptors = @[tagTitle];
    
    NSError *fetchError = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"tagName" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:&fetchError];
    
    
    //[self addTags];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addReceiptButton:(id)sender {
    
    [self.delegate addNewReceiptWithAmount:[self.amountField.text floatValue] note:self.descriptionField.text date:self.datePicker.date andTagSet:self.tagSelectedSet ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!self.tagSelectedSet) {
        self.tagSelectedSet = [NSMutableSet new];
    }
    
    [self.tagSelectedSet addObject:cell.textLabel.text];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!self.tagSelectedSet) {
        self.tagSelectedSet = [NSMutableSet new];
    }
    [self.tagSelectedSet removeObject:cell.textLabel.text];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Tag *tagObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tagObject.tagName;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


//-(void)testTagsSelected {
//    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
//    
//    
//    NSSortDescriptor *tagTitle = [NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES];
//    fetchRequest.sortDescriptors = @[tagTitle];
//    
//    NSError *fetchError = nil;
//    
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"tagName" cacheName:nil];
//    self.fetchedResultsController.delegate = self;
//    [self.fetchedResultsController performFetch:&fetchError];
//    
//    
//    NSError *error;
//    NSArray *dataArray = [self.context executeFetchRequest:fetchRequest error:&error];
//    
//    for (Tag *tag in dataArray) {
//        //   tag.receipt = newRecipt;
//        
//    }
//    
//    [self.context save:&error];
//    
//}


-(void)addTags {
    
    NSArray *tagsArray = @[@"Personal",@"Family",@"Work"];
    
    for (NSString *tags in tagsArray) {
        
        Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.context];
        newTag.tagName = tags;
        NSError *error;
        [self.context save:&error];
    }
}

@end
