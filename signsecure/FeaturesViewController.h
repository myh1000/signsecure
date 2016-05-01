//
//  FeaturesViewController.h
//  SignSecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>

@interface FeaturesViewController : NSViewController
@property (weak) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet WebView *wbv;
@property (weak) IBOutlet NSButton *foward;
@property (weak) IBOutlet NSButton *backward;

@end
