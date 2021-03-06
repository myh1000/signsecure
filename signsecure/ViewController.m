//
//  ViewController.m
//  signsecure
//
//  Created by family on 4/30/16.
//  Copyright © 2016 signsecure. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import <QuartzCore/QuartzCore.h>
#import "MyCustomAnimator.h"
#import "FeaturesViewController.h"

@interface ViewController ()
{
    NSMutableData* data;
    NSString* usernameS;
}

@property (strong, nonatomic) Firebase* ref;

@end

@implementation ViewController
@synthesize statusField;
@synthesize username;
@synthesize password;
@synthesize submit;
@synthesize largeText;
@synthesize ref;
@synthesize signInText;
@synthesize welcomeText;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInText.alphaValue = 0.0;
    self.welcomeText.alphaValue = 0.0;
    data = [[NSMutableData alloc]init];
    self.ref = [[Firebase alloc] initWithUrl:@"https://signatureauthentication.firebaseIO.com"];
    [ref unauth];
    [self.username becomeFirstResponder];
    [self getStatus];
        // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self getStatus];
}

- (void)viewDidLayout{
    [super viewDidLayout];
    self.password.enabled = YES;
    self.username.enabled = YES;
//    self.view.layer.backgroundColor = [NSColor colorWithRed:0.0 green:0.8 blue:0.8 alpha:1.0].CGColor;
    self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"background.png"]]CGColor];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)usernameEnter:(id)sender {
    [self.password becomeFirstResponder];
}

- (IBAction)passwordEnter:(id)sender {
    NSLog(@"enterrr");
    [self submitPressed:sender];
}


- (IBAction)submitPressed:(id)sender {
    [self submitLogin];
}

- (void)getStatus {
    if (ref.authData) {
        // user authenticated
        NSLog(@"%@", ref.authData);
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not logged in (1 of 2)"];
    } else {
       self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not logged in (0 of 2)"];
    }
}


- (void) submitLogin {
    NSLog(@"call");
    NSString *email = [self.username stringValue];
    
    [ref authUser:email password:[self.password stringValue] withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        if (ref.authData) {
            NSLog(@"logged in already");
        }
        else {
        NSLog(@"err log");
            [self shakeAnimation:self.password];
        }
    } else {
        [self getStatus];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:.8];
            self.username.animator.alphaValue = 0.0;
            self.password.animator.alphaValue = 0.0;
            self.submit.animator.alphaValue = 0.0;
        } completionHandler:^(){
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setDuration:1.2];
                self.signInText.animator.alphaValue = 1.0;
            } completionHandler:nil];
        }];
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if([email  isEqual: @"myh1000@gmail.com"])
            {
                NSMutableDictionary *vars = [NSMutableDictionary new];
                usernameS = @"Michael_Huang";
                [vars setObject:usernameS forKey:@"username"];
                [self send_url_encoded_http_post_request:vars];
            }
            else if([email  isEqual: @"kevinfrans2@gmail.com"])
            {
                NSMutableDictionary *vars = [NSMutableDictionary new];
                usernameS = @"Kevin_Frans";
                [vars setObject:usernameS forKey:@"username"];
                
                [self send_url_encoded_http_post_request:vars];
    
            }
            else if([email  isEqual: @"kevkev00123@gmail.com"])
            {
                NSMutableDictionary *vars = [NSMutableDictionary new];
                usernameS = @"Kevin_Fang";
                [vars setObject:usernameS forKey:@"username"];
                
                [self send_url_encoded_http_post_request:vars];
    
            }
            else if([email  isEqual: @"liliatangxy@gmail.com"])
            {
                NSMutableDictionary *vars = [NSMutableDictionary new];
                usernameS = @"Lilia_Tang";
                [vars setObject:usernameS forKey:@"username"];
                
                [self send_url_encoded_http_post_request:vars];
    
            }
        });
    }
    }];
}

- (NSString *)urlencode:(NSString *)input {
    const char *input_c = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString new];
    for (NSInteger i = 0, len = strlen(input_c); i < len; i++) {
        unsigned char c = input_c[i];
        if (
            (c >= '0' && c <= '9')
            || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z')
            || c == '-' || c == '.' || c == '_' || c == '~'
            ) {
            [result appendFormat:@"%c", c];
        }
        else {
            [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}

- (void)send_url_encoded_http_post_request:(NSDictionary *)vars {
    NSString *url_str = @"http://21df99ec.ngrok.io/loggedin";
    NSMutableString *vars_str = [NSMutableString new];
    if (vars != nil && vars.count > 0) {
        BOOL first = YES;
        for (NSString *key in vars) {
            if (!first) {
                [vars_str appendString:@"&"];
            }
            first = NO;
            
            [vars_str appendString:[self urlencode:key]];
            [vars_str appendString:@"="];
            [vars_str appendString:[self urlencode:[vars valueForKey:key]]];
        }
    }
    
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[vars_str dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
     NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data setLength:0];
    NSHTTPURLResponse *resp= (NSHTTPURLResponse *) response;
    NSLog(@"got responce with status @push %ld",(long)[resp statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    [data appendData:d];
    
    NSLog(@"recieved data @push %@", data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didfinishLoading%@",responseText);
    if([responseText isEqualToString:@"false"])
    {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"resent");
            [self submitLogin];
        });
        
    }
    else if([responseText isEqualToString:@"true"])
    {
        NSLog(@"im in boys");
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"logged in (2 of 2)"];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:.8];
            self.largeText.animator.alphaValue = 0.0;
            self.signInText.animator.alphaValue = 0.0;
        } completionHandler:^(){
            self.largeText.stringValue = @"Welcome";
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setDuration:1.2];
                self.welcomeText.animator.alphaValue = 1.0;
            } completionHandler:^() {
                self.submit.enabled = NO;
                self.password.enabled = NO;
                self.username.enabled = NO;
                id animator = [[MyCustomAnimator alloc] init];
                NSViewController* vc = [[FeaturesViewController alloc] initWithNibName:nil bundle:nil];
                [[NSUserDefaults standardUserDefaults] setObject:usernameS forKey:@"usernameS"];
                [self presentViewController:vc animator:animator];
            }];
        }];
    }
    else {
        [self shakeAnimation:self.signInText];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"shake");
            [self submitLogin];
        });
    }

}

-(void)shakeAnimation:(NSTextField *)Field {
    NSRect  textFieldFrame = [Field frame];
    
    CGFloat centerX = textFieldFrame.origin.x;
    CGFloat centerY = textFieldFrame.origin.y;
    
    NSPoint origin = NSMakePoint(centerX, centerY);
    NSPoint one = NSMakePoint(centerX-5, centerY);
    NSPoint two = NSMakePoint(centerX+5, centerY);
    
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setCompletionHandler:^{
                
                [NSAnimationContext beginGrouping];
                [[NSAnimationContext currentContext] setCompletionHandler:^{
                    
                    [[NSAnimationContext currentContext] setDuration:0.03];
                    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                    [[Field animator] setFrameOrigin:origin];
                    
                }];
                
                [[NSAnimationContext currentContext] setDuration:0.03];
                [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                [[Field animator] setFrameOrigin:two];
                [NSAnimationContext endGrouping];
                
            }];
            
            [[NSAnimationContext currentContext] setDuration:0.03];
            [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
            [[Field animator] setFrameOrigin:one];
            [NSAnimationContext endGrouping];
        }];
        
        [[NSAnimationContext currentContext] setDuration:0.03];
        [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [[Field animator] setFrameOrigin:two];
        [NSAnimationContext endGrouping];
        
    }];
    
    [[NSAnimationContext currentContext] setDuration:0.03];
    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    [[Field animator] setFrameOrigin:one];
    [NSAnimationContext endGrouping];
}


@end
