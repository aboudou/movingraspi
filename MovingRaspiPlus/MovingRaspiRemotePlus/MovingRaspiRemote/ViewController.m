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
@synthesize btnForward, btnReverse, btnLeft, btnRight;
@synthesize controlType;

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

    // Gyroscopic control part. Will enable it if the device supports it :
    // iPhone 4 and newer, iPad 2 and newer, iPod touch 4G (iPhone 4 form factor) and newer.
    _motionManager = [[CMMotionManager alloc] init];
    _gyroData = [[CMGyroData alloc] init];
    
    [controlType setOn:FALSE];
    
    if (_motionManager.gyroAvailable == NO) {
        [controlType setEnabled:NO];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)goForward:(id)sender {
    [self sendCommand:@"forward"];
}


- (IBAction)goReverse:(id)sender {
    [self sendCommand:@"reverse"];
}


- (IBAction)turnLeft:(id)sender {
    [self sendCommand:@"left"];
}


- (IBAction)turnRight:(id)sender {
    [self sendCommand:@"right"];
}


- (IBAction)stop:(id)sender {
    _previousMove = @"";
    [self sendCommand:@"stop"];
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

- (IBAction)controlTypeChanged:(id)sender {
    if ([controlType isOn]) {
        
        [btnForward setEnabled:NO];
        [btnForward setHidden:YES];
        [btnReverse setEnabled:NO];
        [btnReverse setHidden:YES];
        [btnLeft setEnabled:NO];
        [btnLeft setHidden:YES];
        [btnRight setEnabled:NO];
        [btnRight setHidden:YES];
        
        // Start to listen for gyro updates.
        NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
        [_motionManager startGyroUpdatesToQueue:theQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
            _gyroData = _motionManager.gyroData;
            
            int x = _gyroData.rotationRate.x;
            int y = _gyroData.rotationRate.y;
            
            // Set the value limit to 2 in order to lower sensitivity
            if (x > 2 && ![_previousMove isEqualToString:@"reverse"]) {
                [self sendCommand:@"reverse"];
                _previousMove = @"reverse";
            } else if (x < -2 && ![_previousMove isEqualToString:@"forward"]) {
                [self sendCommand:@"forward"];
                _previousMove = @"forward";
            }

            if (y > 2 && ![_previousMove isEqualToString:@"right"]) {
                [self sendCommand:@"right"];
                _previousMove = @"right";
            } else if (y < -2 && ![_previousMove isEqualToString:@"left"]) {
                [self sendCommand:@"left"];
                _previousMove = @"left";
            }
            
        }];
    } else {
        _previousMove = @"";
        [self sendCommand:@"stop"];
        [_motionManager stopGyroUpdates];
        [btnForward setEnabled:YES];
        [btnForward setHidden:NO];
        [btnReverse setEnabled:YES];
        [btnReverse setHidden:NO];
        [btnLeft setEnabled:YES];
        [btnLeft setHidden:NO];
        [btnRight setEnabled:YES];
        [btnRight setHidden:NO];
    }
}

#pragma mark - Misc

- (void) sendCommand:(NSString *)command {
    NSLog(@"%@", command);
        NSData *data = [[NSData alloc] initWithData:[command dataUsingEncoding:NSASCIIStringEncoding]];
        [_outputStream write:[data bytes] maxLength:[data length]];
}


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
