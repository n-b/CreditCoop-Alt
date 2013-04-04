// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOAccount.m instead.

#import "_COOAccount.h"

const struct COOAccountAttributes COOAccountAttributes = {
	.balance = @"balance",
	.balanceDate = @"balanceDate",
	.category = @"category",
	.label = @"label",
	.number = @"number",
};

const struct COOAccountRelationships COOAccountRelationships = {
	.operations = @"operations",
	.user = @"user",
};

const struct COOAccountFetchedProperties COOAccountFetchedProperties = {
};

@implementation COOAccountID
@end

@implementation _COOAccount

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Account";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Account" inManagedObjectContext:moc_];
}

- (COOAccountID*)objectID {
	return (COOAccountID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic balance;






@dynamic balanceDate;






@dynamic category;






@dynamic label;






@dynamic number;






@dynamic operations;

	
- (NSMutableOrderedSet*)operationsSet {
	[self willAccessValueForKey:@"operations"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"operations"];
  
	[self didAccessValueForKey:@"operations"];
	return result;
}
	

@dynamic user;

	






@end
