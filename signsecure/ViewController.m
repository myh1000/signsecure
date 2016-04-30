//
//  ViewController.m
//  signsecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize statusField;
@synthesize username;
@synthesize password;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getStatus];
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
    self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In"];
}


- (void) submitLogin {
    NSLog(@"call");
    [self getStatus];
}


@end
