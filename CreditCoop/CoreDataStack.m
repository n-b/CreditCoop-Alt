#import "CoreDataStack.h"

@interface CoreDataStack ()
@property NSManagedObjectModel *mom;
@property NSPersistentStoreCoordinator *psc;
@property NSManagedObjectContext *moc;
@end

@implementation CoreDataStack

- (id) init
{
   return [self initWithModelName:NSStringFromClass([self class])];
}

- (id) initWithModelName:(NSString*)modelName
{
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:[modelName stringByAppendingPathExtension:@"sqlite"]]];
    return [self initWithModelName:modelName storeURL:storeURL];
}

- (id) initWithModelName:(NSString*)modelName storeURL:(NSURL*)storeURL
{
    self = [super init];
    if (self) {
        
        // Create mom
		self.mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:modelName ofType:@"momd"]]]; 
        
        // Create psc
		self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
		NSError *error = nil;
        
        // Debug
		if([[NSUserDefaults standardUserDefaults] boolForKey:@"DebugRemoveStore"])
        {
			NSLog(@"Removing data store");
			[[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
        }
        
        // Copy embedded store, if we don't already have a store in the final location, and there's one in the app bundle.
        if( ![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
        {
            NSString * storeName = [[storeURL.path lastPathComponent] stringByDeletingPathExtension];
            NSURL * embeddedStoreURL = [[NSBundle mainBundle] URLForResource:storeName withExtension:@"sqlite"];
            if(embeddedStoreURL)
                [[NSFileManager defaultManager] copyItemAtURL:embeddedStoreURL toURL:storeURL error:NULL];
        }
        
        // Create PSC
		if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
			NSLog(@"Unresolved error when opening store %@, %@", error, [error userInfo]);
			if( error.code == NSPersistentStoreIncompatibleVersionHashError )
            {
                // This happens a lot during development. Just dump the old store and create a new one.
				NSLog(@"trying to remove the existing db");
				[[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
				[self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];	
            }
			else
                // shit.
				abort();
        }
		
        // Create moc
        self.moc = [NSManagedObjectContext new];
		self.moc.persistentStoreCoordinator = self.psc;
		self.moc.undoManager = nil;
    }
    return self;
}

- (BOOL) save:(NSError**)saveError
{
    return [self.moc save:saveError];
}

@end
