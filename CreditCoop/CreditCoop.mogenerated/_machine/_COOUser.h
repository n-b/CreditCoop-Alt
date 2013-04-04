// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOUser.h instead.

#import <CoreData/CoreData.h>


extern const struct COOUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *label;
	__unsafe_unretained NSString *lastConnectionDate;
} COOUserAttributes;

extern const struct COOUserRelationships {
	__unsafe_unretained NSString *accounts;
} COOUserRelationships;

extern const struct COOUserFetchedProperties {
} COOUserFetchedProperties;

@class COOAccount;





@interface COOUserID : NSManagedObjectID {}
@end

@interface _COOUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (COOUserID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* label;



//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastConnectionDate;



//- (BOOL)validateLastConnectionDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *accounts;

- (NSMutableOrderedSet*)accountsSet;





@end

@interface _COOUser (CoreDataGeneratedAccessors)

- (void)addAccounts:(NSOrderedSet*)value_;
- (void)removeAccounts:(NSOrderedSet*)value_;
- (void)addAccountsObject:(COOAccount*)value_;
- (void)removeAccountsObject:(COOAccount*)value_;

@end

@interface _COOUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveLabel;
- (void)setPrimitiveLabel:(NSString*)value;




- (NSString*)primitiveLastConnectionDate;
- (void)setPrimitiveLastConnectionDate:(NSString*)value;





- (NSMutableOrderedSet*)primitiveAccounts;
- (void)setPrimitiveAccounts:(NSMutableOrderedSet*)value;


@end
