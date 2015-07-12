
@interface NSManagedObject (Importing)
- (void) importValues:(NSDictionary*)values_;
@end

@interface NSManagedObject (COOMapping)
+ (NSDictionary*) coomapping;
@end
