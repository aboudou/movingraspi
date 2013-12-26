//
//  SettingsViewController.m
//  MovingRaspiRemotePlus
//
//  Created by Arnaud Boudou on 26/12/2013.
//  Copyright (c) 2013 Arnaud Boudou. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Load user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"] != nil) {
        [self.host setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.host"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"] != nil) {
        [self.port setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.port"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.pcvPort"] != nil) {
        [self.pcvPort setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.pcvPort"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.mjpegUrl"] != nil) {
        [self.mjpegUrl setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.mjpegUrl"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.controlType"] != nil) {
        NSString *ctrlType = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.aboudou.movingraspiremote.controlType"];
        if ([ctrlType isEqualToString:@"gyroscopic"]) {
            [self.controlType setOn:YES];
        } else {
            [self.controlType setOn:NO];
        }
    } else {
        [self.controlType setOn:NO];
    }
    
    CMMotionManager *_motionManager = [[CMMotionManager alloc] init];
    if (_motionManager.gyroAvailable == NO) {
        [self.controlType setEnabled:NO];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction) saveAction:(id)sender {
    // Save user defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.host text] forKey:@"com.aboudou.movingraspiremote.host"];
    [defaults setObject:[self.port text] forKey:@"com.aboudou.movingraspiremote.port"];
    [defaults setObject:[self.pcvPort text] forKey:@"com.aboudou.movingraspiremote.pcvPort"];
    [defaults setObject:[self.mjpegUrl text] forKey:@"com.aboudou.movingraspiremote.mjpegUrl"];
    if (self.controlType.isOn) {
        [defaults setObject:@"gyroscopic" forKey:@"com.aboudou.movingraspiremote.controlType"];
    } else {
        [defaults setObject:@"manual" forKey:@"com.aboudou.movingraspiremote.controlType"];
    }
    [defaults synchronize];
    
    // Close view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) cancelAction:(id)sender {
    // Close view
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Misc

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.host resignFirstResponder];
    [self.port resignFirstResponder];
    [self.pcvPort resignFirstResponder];
    [self.mjpegUrl resignFirstResponder];
}

@end
