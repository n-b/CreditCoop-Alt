// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOAccount.h instead.

#import <CoreData/CoreData.h>


extern const struct COOAccountAttributes {
	__unsafe_unretained NSString *balance;
	__unsafe_unretained NSString *balanceDate;
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *label;
	__unsafe_unretained NSString *number;
} COOAccountAttributes;

extern const struct COOAccountRelationships {
	__unsafe_unretained NSString *operations;
	__unsafe_unretained NSString *user;
} COOAccountRelationships;

extern const struct COOAccountFetchedProperties {
} COOAccountFetchedProperties;

@class COOOperation;
@class COOUser;







@interface COOAccountID : NSManagedObjectID {}
@end

@interface _COOAccount : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (COOAccountID*)objectID;





@property (nonatomic, strong) NSDecimalNumber* balance;



//- (BOOL)validateBalance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* balanceDate;



//- (BOOL)validateBalanceDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* category;



//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* label;



//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* number;



//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *operations;

- (NSMutableOrderedSet*)operationsSet;




@property (nonatomic, strong) COOUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _COOAccount (CoreDataGeneratedAccessors)

- (void)addOperations:(NSOrderedSet*)value_;
- (void)removeOperations:(NSOrderedSet*)value_;
- (void)addOperationsObject:(COOOperation*)value_;
- (void)removeOperationsObject:(COOOperation*)value_;

@end

@interface _COOAccount (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber*)primitiveBalance;
- (void)setPrimitiveBalance:(NSDecimalNumber*)value;




- (NSString*)primitiveBalanceDate;
- (void)setPrimitiveBalanceDate:(NSString*)value;




- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSString*)primitiveLabel;
- (void)setPrimitiveLabel:(NSString*)value;




- (NSString*)primitiveNumber;
- (void)setPrimitiveNumber:(NSString*)value;





- (NSMutableOrderedSet*)primitiveOperations;
- (void)setPrimitiveOperations:(NSMutableOrderedSet*)value;



- (COOUser*)primitiveUser;
- (void)setPrimitiveUser:(COOUser*)value;


@end
