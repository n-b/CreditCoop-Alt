// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOOperation.m instead.

#import "_COOOperation.h"

const struct COOOperationAttributes COOOperationAttributes = {
	.amount = @"amount",
	.date = @"date",
	.label1 = @"label1",
	.label2 = @"label2",
};

const struct COOOperationRelationships COOOperationRelationships = {
	.account = @"account",
};

const struct COOOperationFetchedProperties COOOperationFetchedProperties = {
};

@implementation COOOperationID
@end

@implementation _COOOperation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Operation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Operation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Operation" inManagedObjectContext:moc_];
}

- (COOOperationID*)objectID {
	return (COOOperationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic amount;






@dynamic date;






@dynamic label1;






@dynamic label2;






@dynamic account;

	






@end
