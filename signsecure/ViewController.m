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
@synthesize largeText;
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [[NSMutableData alloc]init];

    
    self.ref = [[Firebase alloc] initWithUrl:@"https://signatureauthentication.firebaseIO.com"];
    [self getStatus];
        // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
}

- (void)viewDidLayout{
    [super viewDidLayout];
    self.view.layer.backgroundColor = [NSColor colorWithRed:0.0 green:0.8 blue:0.8 alpha:1.0].CGColor;
    self.statusField.textColor = [NSColor whiteColor];
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
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (1 of 2)"];
    } else {
       self.statusField.stringValue = [@"Status: " stringByAppendingString:@"not Logged In (0 of 2)"];
    }
    self.largeText.stringValue = @"Sine Secure";
}


- (void) submitLogin {
    NSLog(@"call");
    NSString *email = [self.username stringValue];
    
    [ref authUser:email password:[self.password stringValue] withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        NSLog(@"err log");
    } else {
        [self getStatus];
        if([email  isEqual: @"myh1000@gmail.com"])
        {
            NSMutableDictionary *vars = [NSMutableDictionary new];
            [vars setObject:@"Michael_Huang" forKey:@"username"];
            
            [self send_url_encoded_http_post_request:vars];
        }
        else if([email  isEqual: @"kevinfrans2@gmail.com"])
        {
            NSMutableDictionary *vars = [NSMutableDictionary new];
            [vars setObject:@"Kevin_Frans" forKey:@"username"];
            
            [self send_url_encoded_http_post_request:vars];

        }
        else if([email  isEqual: @"myh1000@gmail.com"])
        {
            NSMutableDictionary *vars = [NSMutableDictionary new];
            [vars setObject:@"Kevin_Fang" forKey:@"username"];
            
            [self send_url_encoded_http_post_request:vars];

        }
        else if([email  isEqual: @"myh1000@gmail.com"])
        {
            NSMutableDictionary *vars = [NSMutableDictionary new];
            [vars setObject:@"Lilia_Tang" forKey:@"username"];
            
            [self send_url_encoded_http_post_request:vars];

        }
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
    NSString *url_str = @"http://e02e18e8.ngrok.io/loggedin";
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
    NSLog(@"got responce with status @push %d",[resp statusCode]);
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
    else
    {
        NSLog(@"im in boys");
        self.statusField.stringValue = [@"Status: " stringByAppendingString:@"Logged In (2 of 2)"];
        self.largeText.stringValue = @"Welcome";
    }
    
}


@end
