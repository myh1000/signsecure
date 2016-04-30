//
//  ViewController.h
//  signsecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *statusField;
@property (weak) IBOutlet NSTextField *username;
@property (weak) IBOutlet NSSecureTextField *password;
@property (weak) IBOutlet NSTextField *largeText;

@end

