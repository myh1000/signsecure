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

@interface ViewController ()
{
    NSMutableData* data;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [[NSMutableData alloc]init];
    self.ref = [[Firebase alloc] initWithUrl:@"https://signatureauthentication.firebaseIO.com"];
    [ref unauth];
    [self getStatus];
        // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self.submit setKeyEquivalent:@"\r"];
    [self getStatus];
}

- (void)viewDidLayout{
    [super viewDidLayout];
//    self.view.layer.backgroundColor = [NSColor colorWithRed:0.0 green:0.8 blue:0.8 alpha:1.0].CGColor;
    self.view.layer.backgroundColor = [[NSColor colorWithPatternImage:[NSImage imageNamed:@"background.png"]]CGColor];
    [self.username becomeFirstResponder];
    self.largeText.alphaValue = 0.0;
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
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (1 of 2)"];
    } else {
       self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (0 of 2)"];
    }
}


- (void) submitLogin {
    NSLog(@"call");
    NSString *email = [self.username stringValue];
    
    [ref authUser:email password:[self.password stringValue] withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        NSLog(@"err log");
        [self shakeAnimation];
    } else {
        [self getStatus];
        if([email  isEqual: @"myh1000@gmail.com"])
        {
            NSMutableDictionary *vars = [NSMutableDictionary new];
            [vars setObject:@"Michael_Huang" forKey:@"username"];
            
            [self send_url_encoded_http_post_request:vars];
        }
//        else if([email  isEqual: @"kevinfrans2@gmail.com"])
//        {
//            NSMutableDictionary *vars = [NSMutableDictionary new];
//            [vars setObject:@"Kevin_Frans" forKey:@"username"];
//            
//            [self send_url_encoded_http_post_request:vars];
//
//        }
//        else if([email  isEqual: @"myh1000@gmail.com"])
//        {
//            NSMutableDictionary *vars = [NSMutableDictionary new];
//            [vars setObject:@"Kevin_Fang" forKey:@"username"];
//            
//            [self send_url_encoded_http_post_request:vars];
//
//        }
//        else if([email  isEqual: @"myh1000@gmail.com"])
//        {
//            NSMutableDictionary *vars = [NSMutableDictionary new];
//            [vars setObject:@"Lilia_Tang" forKey:@"username"];
//            
//            [self send_url_encoded_http_post_request:vars];
//
//        }
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
    NSString *url_str = @"http://7ac770f8.ngrok.io/loggedin";
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
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"Logged In (2 of 2)"];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:2.0];
            self.largeText.animator.alphaValue = 1.0;
        } completionHandler:^(){
            //Completion Code
        }];
        self.submit.enabled = NO;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://google.com"]];
        NSLog(@"open secure.html");
        });
    }
    else {
        [self shakeAnimation];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"resent");
            [self submitLogin];
        });
    }

}

-(void)shakeAnimation {
    NSRect textFieldFrame = [self.password frame];
    
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
                    
                    [[NSAnimationContext currentContext] setDuration:0.0175];
                    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                    [[self.password animator] setFrameOrigin:origin];
                    
                }];
                
                [[NSAnimationContext currentContext] setDuration:0.0175];
                [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
                [[self.password animator] setFrameOrigin:two];
                [NSAnimationContext endGrouping];
                
            }];
            
            [[NSAnimationContext currentContext] setDuration:0.0175];
            [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
            [[self.password animator] setFrameOrigin:one];
            [NSAnimationContext endGrouping];
        }];
        
        [[NSAnimationContext currentContext] setDuration:0.0175];
        [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [[self.password animator] setFrameOrigin:two];
        [NSAnimationContext endGrouping];
        
    }];
    
    [[NSAnimationContext currentContext] setDuration:0.0175];
    [[NSAnimationContext currentContext] setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
    [[self.password animator] setFrameOrigin:one];
    [NSAnimationContext endGrouping];
}


@end
