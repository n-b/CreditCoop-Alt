@import CoreData;

@interface CoreDataStack : NSObject

- (instancetype)init;									// default model name is NSStringFromClass([self class])
- (instancetype)initWithModelName:(NSString*)modelName;	// default store url is ~/Documents/<modelName>.sqlite
- (instancetype)initWithModelName:(NSString*)modelName storeURL:(NSURL*)storeURL NS_DESIGNATED_INITIALIZER;

@property (readonly) NSManagedObjectContext *moc;

- (BOOL)save:(NSError**)saveError;

@end
