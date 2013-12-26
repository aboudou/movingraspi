//
//  SettingsViewController.h
//  MovingRaspiRemotePlus
//
//  Created by Arnaud Boudou on 26/12/2013.
//  Copyright (c) 2013 Arnaud Boudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITextField *host;
@property(nonatomic, strong) IBOutlet UITextField *port;
@property(nonatomic, strong) IBOutlet UITextField *pcvPort;
@property(nonatomic, strong) IBOutlet UITextField *mjpegUrl;

@property(nonatomic, strong) IBOutlet UIButton *btnSave;
@property(nonatomic, strong) IBOutlet UIButton *btnCancel;

@property(nonatomic, strong) IBOutlet UISwitch *controlType;

- (IBAction) saveAction:(id)sender;
- (IBAction) cancelAction:(id)sender;

@end
