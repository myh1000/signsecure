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
    [self getStatus];
    self.ref = [[Firebase alloc] initWithUrl:@"https://signatureauthentication.firebaseIO.com"];
    [self.statusField sizeToFit];
   
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self.username becomeFirstResponder];
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
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"Logged In"];
    } else {
       self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In"];
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
