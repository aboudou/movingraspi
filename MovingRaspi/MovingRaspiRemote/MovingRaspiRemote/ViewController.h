//
//  ViewController.h
//  MovingRaspiRemote
//
//  Created by Arnaud Boudou on 03/12/12.
//  Copyright (c) 2012 Arnaud Boudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate> {
    BOOL _connectInProgress;
    
    NSOutputStream *_outputStream;
}

@property(nonatomic, strong) IBOutlet UITextField *host;
@property(nonatomic, strong) IBOutlet UITextField *port;
@property(nonatomic, strong) IBOutlet UIButton *connect;
@property(nonatomic, strong) IBOutlet UIButton *disconnect;
@property(nonatomic, strong) IBOutlet UILabel *status;

- (IBAction)doConnect:(id)sender;
- (IBAction)doDisconnect:(id)sender;

- (IBAction)goForward:(id)sender;
- (IBAction)goReverse:(id)sender;
- (IBAction)turnLeft:(id)sender;
- (IBAction)turnRight:(id)sender;

- (IBAction)stop:(id)sender;

@end
