//
//  ViewController.m
//  MovingRaspiRemote
//
//  Created by Arnaud Boudou on 03/12/12.
//  Copyright (c) 2012 Arnaud Boudou. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.status setText:@"Not connected"];
    
    // Gyroscopic control part. Will enable it if the device supports it :
    // iPhone 4 and newer, iPad 2 and newer, iPod touch 4G (iPhone 4 form factor) and newer.
    _motionManager = [[CMMotionManager alloc] init];
    _gyroData = [[CMGyroData alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"] != nil) {
        _currentHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"] != nil) {
        _currentPort = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.pcvPort"] != nil) {
        _currentPcvPort = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.pcvPort"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.mjpegUrl"] != nil) {
        _currentMjpegUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.mjpegUrl"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.controlType"] != nil) {
        _currentCtrlType = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.controlType"];
    } else {
        _currentCtrlType = @"manual";
    }
    [self controlTypeChanged:nil];

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
    [self doDisconnect:nil];
    [self initNetworkCommunication];
    _connectInProgress = YES;
    
    [self.status setText:@"Connection in progress…"];
    [self performSelectorInBackground:@selector(waitForConnection:) withObject:nil];
    
    if ([_currentPcvPort length] > 0) {
        [self performSelectorInBackground:@selector(piCheckVoltageStatus:) withObject:nil];
    }

    if ([_currentMjpegUrl length] > 0) {
        [self performSelector:@selector(startVideoStream) withObject:nil];
    }
}


- (IBAction)doDisconnect:(id)sender {
    [_outputStream close];
    [_inputStream close];
    
    _connectInProgress = NO;
    
    [self.batteryLevel setProgress:0.0 animated:YES];
    
    [self.streamView stop];
    
    [self.status setText:@"Not connected"];
}

- (IBAction)controlTypeChanged:(id)sender {
    if ([_currentCtrlType isEqualToString:@"gyroscopic"]) {
        
        [self.btnForward setEnabled:NO];
        [self.btnForward setHidden:YES];
        [self.btnReverse setEnabled:NO];
        [self.btnReverse setHidden:YES];
        [self.btnLeft setEnabled:NO];
        [self.btnLeft setHidden:YES];
        [self.btnRight setEnabled:NO];
        [self.btnRight setHidden:YES];
        
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
        [self.btnForward setEnabled:YES];
        [self.btnForward setHidden:NO];
        [self.btnReverse setEnabled:YES];
        [self.btnReverse setHidden:NO];
        [self.btnLeft setEnabled:YES];
        [self.btnLeft setHidden:NO];
        [self.btnRight setEnabled:YES];
        [self.btnRight setHidden:NO];
    }
}

- (IBAction)openSettings:(id)sender {
    // Disconnect
    [self doDisconnect:nil];
    
    // Open settings view
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:settingsController];
    [controller.navigationBar setHidden:YES];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Misc

- (void) sendCommand:(NSString *)command {
    NSData *data = [[NSData alloc] initWithData:[command dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
}


- (void) waitForConnection:(id) sender {
    @autoreleasepool {
        // Connect to MovingRaspi server
        
        while (([_outputStream streamStatus] != NSStreamStatusOpen && [_outputStream streamStatus] != NSStreamStatusError) && _connectInProgress) {
            [self.status performSelectorOnMainThread:@selector(setText:) withObject:@"Connection in progress…" waitUntilDone:YES];
        }
        if ([_outputStream streamStatus] == NSStreamStatusOpen) {
            [self.status performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Connected to %@:%@", _currentHost, _currentPort] waitUntilDone:YES];
        } else if ([_outputStream streamStatus] == NSStreamStatusError) {
            [self.status performSelectorOnMainThread:@selector(setText:) withObject:@"Could not connect to MovingRaspi" waitUntilDone:YES];
        } else {
            [self.status performSelectorOnMainThread:@selector(setText:) withObject:@"Not connected to MovingRaspi" waitUntilDone:YES];
        }
    }
}


- (void) piCheckVoltageStatus:(id) sender {
    @autoreleasepool {
        while (_connectInProgress) {
            // Connect to PiCheckVoltage server
            
            CFReadStreamRef readStream;
            CFWriteStreamRef writeStream;
            CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)CFBridgingRetain(_currentHost), [_currentPcvPort intValue], &readStream, &writeStream);
            _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
        
            [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_inputStream open];
        
            uint8_t buffer[1024];
            int len;
        
            len = [_inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                
                NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                
                if (nil != output) {
                    [self performSelectorOnMainThread:@selector(updateBatteryLevel:) withObject:output waitUntilDone:NO];
                }
            }
        
            [_inputStream close];
            
            [NSThread sleepForTimeInterval:30];

        }
    }
}

- (void) updateBatteryLevel:(NSString *) pcvReturn {
    @autoreleasepool {
        NSArray *values = [pcvReturn componentsSeparatedByString: @"|"];

        float progress = (([[values objectAtIndex:2] floatValue]-[[values objectAtIndex:0] floatValue])-([[values objectAtIndex:2] floatValue]-[[values objectAtIndex:1] floatValue]))/([[values objectAtIndex:2] floatValue]-[[values objectAtIndex:0] floatValue]);
        
        if (progress < 0.1) {
            [self.batteryLevel setProgressTintColor:[UIColor redColor]];
        } else if (progress < 0.25) {
            [self.batteryLevel setProgressTintColor:[UIColor orangeColor]];
        } else {
            [self.batteryLevel setProgressTintColor:[UIColor greenColor]];
        }
        
        [self.batteryLevel setProgress:progress animated:YES];
    }
}


- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)CFBridgingRetain(_currentHost), [_currentPort intValue], &readStream, &writeStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_outputStream open];
}

- (void)startVideoStream {
    NSURL *url = [NSURL URLWithString:_currentMjpegUrl];
    self.streamView.url = url;
    [self.streamView play];
}

@end
