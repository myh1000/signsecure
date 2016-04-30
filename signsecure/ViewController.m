//
//  ViewController.m
//  signsecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
@interface ViewController ()

@property (strong, nonatomic) Firebase* ref;

@end

@implementation ViewController
@synthesize statusField;
@synthesize username;
@synthesize password;
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[Firebase alloc] initWithUrl:@"https://signatureauthentication.firebaseIO.com"];
    [self getStatus];
    [self.username becomeFirstResponder];
        // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)submitPressed:(id)sender {
    [self submitLogin];
}

- (void)getStatus {
    if (ref.authData) {
        // user authenticated
        NSLog(@"%@", ref.authData);
        if (1==2) {
            self.statusField.stringValue = [@"Status: " stringByAppendingString:@"Logged In (2 of 2)"];

        }
        else {
            self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (1 of 2)"];
        }
    } else {
       self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (0 of 2)"];
    }
}


- (void) submitLogin {
    NSLog(@"call");
    [ref authUser:[self.username stringValue] password:[self.password stringValue] withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        NSLog(@"err log");
    } else {
        [self getStatus];
    }
    }];
}


@end
