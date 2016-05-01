//
//  FeaturesViewController.m
//  SignSecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "FeaturesViewController.h"

@interface FeaturesViewController ()

@end

@implementation FeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Presented ViewController";
}


- (IBAction)dismiss:(id)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewController:self];
    } else {
        //for the 'show' transition
        [self.view.window close];
    }
}

@end
