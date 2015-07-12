@import CoreData;

@interface CoreDataStack : NSObject

- (id) init;									// default model name is NSStringFromClass([self class])
- (id) initWithModelName:(NSString*)modelName;	// default store url is ~/Documents/<modelName>.sqlite
- (id) initWithModelName:(NSString*)modelName storeURL:(NSURL*)storeURL;

@property (readonly) NSManagedObjectContext *moc;

- (BOOL) save:(NSError**)saveError;

@end
