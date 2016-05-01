//
//  FeaturesViewController.m
//  SignSecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "FeaturesViewController.h"

@implementation FeaturesViewController 

@synthesize urlField;
@synthesize wbv;
@synthesize foward;
@synthesize backward;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[wbv mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlField stringValue]]]];
}

- (IBAction)foward:(id)sender {
    [wbv goForward];
}
- (IBAction)backward:(id)sender {
    [wbv goBack];
}

- (IBAction)submit:(id)sender {
    [[wbv mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlField stringValue]]]];
}

- (IBAction)cancel:(id)sender {
    [wbv stopLoading:sender];
 }

@end
