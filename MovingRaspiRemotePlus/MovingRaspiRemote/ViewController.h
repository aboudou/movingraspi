//
//  ViewController.h
//  MovingRaspiRemote
//
//  Created by Arnaud Boudou on 03/12/12.
//  Copyright (c) 2012 Arnaud Boudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <NSStreamDelegate> {
    BOOL _connectInProgress;
    
    NSOutputStream *_outputStream;
    
    CMMotionManager *_motionManager;
    CMGyroData *_gyroData;

    NSString *_previousMove;
    
}

@property(nonatomic, strong) IBOutlet UITextField *host;
@property(nonatomic, strong) IBOutlet UITextField *port;
@property(nonatomic, strong) IBOutlet UIButton *connect;
@property(nonatomic, strong) IBOutlet UIButton *disconnect;
@property(nonatomic, strong) IBOutlet UILabel *status;

@property(nonatomic, strong) IBOutlet UIButton *btnForward;
@property(nonatomic, strong) IBOutlet UIButton *btnReverse;
@property(nonatomic, strong) IBOutlet UIButton *btnLeft;
@property(nonatomic, strong) IBOutlet UIButton *btnRight;
@property(nonatomic, strong) IBOutlet UIButton *btnStop;

@property(nonatomic, strong) IBOutlet UISwitch *controlType;

- (IBAction)doConnect:(id)sender;
- (IBAction)doDisconnect:(id)sender;

- (IBAction)goForward:(id)sender;
- (IBAction)goReverse:(id)sender;
- (IBAction)turnLeft:(id)sender;
- (IBAction)turnRight:(id)sender;

- (IBAction)stop:(id)sender;

- (IBAction)controlTypeChanged:(id)sender;

@end
