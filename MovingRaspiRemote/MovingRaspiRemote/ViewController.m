//
//  ViewController.m
//  MovingRaspiRemote
//
//  Created by Arnaud Boudou on 03/12/12.
//  Copyright (c) 2012 Arnaud Boudou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize port, host, connect, disconnect, status;

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [status setText:@"Not connected"];
    
    // Load user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"] != nil) {
        [host setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"] != nil) {
        [port setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"]];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)goForward:(id)sender {
    NSString *response  = @"forward";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction)goReverse:(id)sender {
    NSString *response  = @"reverse";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction)turnLeft:(id)sender {
    NSString *response  = @"left";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction)turnRight:(id)sender {
    NSString *response  = @"right";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction)stop:(id)sender {
    NSString *response  = @"stop";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[_outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction)doConnect:(id)sender {
    // Save user defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[host text] forKey:@"com.aboudou.movingraspiremote.host"];
    [defaults setObject:[port text] forKey:@"com.aboudou.movingraspiremote.port"];
    [defaults synchronize];
    
    [[self host] resignFirstResponder];
    [[self port] resignFirstResponder];
    
    [self doDisconnect:nil];
    [self initNetworkCommunication];
    _connectInProgress = YES;
    
    [status setText:@"Connection in progress…"];
    [self performSelectorInBackground:@selector(waitForConnection:) withObject:nil];
}


- (IBAction)doDisconnect:(id)sender {
    [[self host] resignFirstResponder];
    [[self port] resignFirstResponder];

    [_outputStream close];
    
    _connectInProgress = NO;
    
    [status setText:@"Not connected"];
}

#pragma mark - Misc


- (void) waitForConnection:(id) sender {
    @autoreleasepool {
        while ([_outputStream streamStatus] != NSStreamStatusOpen && _connectInProgress) {
            [status performSelectorOnMainThread:@selector(setText:) withObject:@"Connection in progress…" waitUntilDone:YES];
        }
        if (_connectInProgress) {
            [status performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Connected to %@:%@", [self.host text], [self.port text]] waitUntilDone:YES];
        } else {
            [status performSelectorOnMainThread:@selector(setText:) withObject:@"Not connected" waitUntilDone:YES];
        }
    }
}


- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)CFBridgingRetain([self.host text]), [[self.port text] intValue], &readStream, &writeStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [_outputStream setDelegate:self];
    
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_outputStream open];
}

@end
