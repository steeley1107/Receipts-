//
//  Tag+CoreDataProperties.h
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tagName;
@property (nullable, nonatomic, retain) NSSet<Receipt *> *receipt;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addReceiptObject:(Receipt *)value;
- (void)removeReceiptObject:(Receipt *)value;
- (void)addReceipt:(NSSet<Receipt *> *)values;
- (void)removeReceipt:(NSSet<Receipt *> *)values;

@end

NS_ASSUME_NONNULL_END
