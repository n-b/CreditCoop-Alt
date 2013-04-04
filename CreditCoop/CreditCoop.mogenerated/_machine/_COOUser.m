// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to COOUser.m instead.

#import "_COOUser.h"

const struct COOUserAttributes COOUserAttributes = {
	.email = @"email",
	.label = @"label",
	.lastConnectionDate = @"lastConnectionDate",
};

const struct COOUserRelationships COOUserRelationships = {
	.accounts = @"accounts",
};

const struct COOUserFetchedProperties COOUserFetchedProperties = {
};

@implementation COOUserID
@end

@implementation _COOUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (COOUserID*)objectID {
	return (COOUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic email;






@dynamic label;






@dynamic lastConnectionDate;






@dynamic accounts;

	
- (NSMutableOrderedSet*)accountsSet {
	[self willAccessValueForKey:@"accounts"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"accounts"];
  
	[self didAccessValueForKey:@"accounts"];
	return result;
}
	






@end
