// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOOperation.h instead.

#import <CoreData/CoreData.h>


extern const struct COOOperationAttributes {
	__unsafe_unretained NSString *amount;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *label1;
	__unsafe_unretained NSString *label2;
} COOOperationAttributes;

extern const struct COOOperationRelationships {
	__unsafe_unretained NSString *account;
} COOOperationRelationships;

extern const struct COOOperationFetchedProperties {
} COOOperationFetchedProperties;

@class COOAccount;






@interface COOOperationID : NSManagedObjectID {}
@end

@interface _COOOperation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (COOOperationID*)objectID;





@property (nonatomic, strong) NSDecimalNumber* amount;



//- (BOOL)validateAmount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* label1;



//- (BOOL)validateLabel1:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* label2;



//- (BOOL)validateLabel2:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) COOAccount *account;

//- (BOOL)validateAccount:(id*)value_ error:(NSError**)error_;





@end

@interface _COOOperation (CoreDataGeneratedAccessors)

@end

@interface _COOOperation (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber*)primitiveAmount;
- (void)setPrimitiveAmount:(NSDecimalNumber*)value;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveLabel1;
- (void)setPrimitiveLabel1:(NSString*)value;




- (NSString*)primitiveLabel2;
- (void)setPrimitiveLabel2:(NSString*)value;





- (COOAccount*)primitiveAccount;
- (void)setPrimitiveAccount:(COOAccount*)value;


@end
