#import "CoreDataStack.h"

@interface CoreDataStack ()
@property NSManagedObjectModel *mom;
@property NSPersistentStoreCoordinator *psc;
@property NSManagedObjectContext *moc;
@end

@implementation CoreDataStack

- (instancetype)init
{
   return [self initWithModelName:NSStringFromClass(self.class)];
}

- (instancetype)initWithModelName:(NSString*)modelName_
{
    NSString * documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSURL *storeURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:[modelName_ stringByAppendingPathExtension:@"sqlite"]]];
    return [self initWithModelName:modelName_ storeURL:storeURL];
}

- (instancetype)initWithModelName:(NSString*)modelName_ storeURL:(NSURL*)storeURL_
{
    self = [super init];
    if (self) {
        
        // Create mom
		self.mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:modelName_ ofType:@"momd"]]];
        
        // Create psc
		self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
		NSError *error = nil;
        
        // Debug
		if([NSUserDefaults.standardUserDefaults boolForKey:@"DebugRemoveStore"])
        {
			NSLog(@"Removing data store");
			[NSFileManager.defaultManager removeItemAtURL:storeURL_ error:NULL];
        }
        
        // Copy embedded store, if we don't already have a store in the final location, and there's one in the app bundle.
        if( ![NSFileManager.defaultManager fileExistsAtPath:storeURL_.path])
        {
            NSString * storeName = storeURL_.path.lastPathComponent.stringByDeletingPathExtension;
            NSURL * embeddedStoreURL = [NSBundle.mainBundle URLForResource:storeName withExtension:@"sqlite"];
            if(embeddedStoreURL)
                [NSFileManager.defaultManager copyItemAtURL:embeddedStoreURL toURL:storeURL_ error:NULL];
        }
        
        // Create PSC
		if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL_ options:nil error:&error])
        {
			NSLog(@"Unresolved error when opening store %@, %@", error, error.userInfo);
			if( error.code == NSPersistentStoreIncompatibleVersionHashError )
            {
                // This happens a lot during development. Just dump the old store and create a new one.
				NSLog(@"trying to remove the existing db");
				[NSFileManager.defaultManager removeItemAtURL:storeURL_ error:NULL];
				[self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL_ options:nil error:&error];	
            }
			else
                // shit.
				abort();
        }
		
        // Create moc
        self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		self.moc.persistentStoreCoordinator = self.psc;
		self.moc.undoManager = nil;
    }
    return self;
}

- (BOOL)save:(NSError**)saveError
{
    return [self.moc save:saveError];
}

@end
