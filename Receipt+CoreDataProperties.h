//
//  Receipt+CoreDataProperties.h
//  Receipts++
//
//  Created by Steele on 2015-11-12.
//  Copyright © 2015 Steele. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Receipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface Receipt (CoreDataProperties)

@property (nonatomic) float amount;
@property (nullable, nonatomic, retain) NSString *note;
@property (nonatomic) NSTimeInterval timeStamp;
@property (nullable, nonatomic, retain) NSSet<Tag *> *tag;

@end

@interface Receipt (CoreDataGeneratedAccessors)

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet<Tag *> *)values;
- (void)removeTag:(NSSet<Tag *> *)values;

@end

NS_ASSUME_NONNULL_END
