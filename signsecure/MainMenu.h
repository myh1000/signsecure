//
//  MainMenu.h
//  SignSecure
//
//  Created by family on 5/1/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "AppDelegate.h"

@interface MainMenu : AppDelegate

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;


@end
