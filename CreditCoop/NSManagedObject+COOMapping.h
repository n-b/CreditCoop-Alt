@import CoreData;

@interface NSManagedObject (COOImporting)
- (void)coo_importValues:(NSDictionary*)values_;
@end
