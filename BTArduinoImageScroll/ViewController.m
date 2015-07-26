//
//  ViewController.m
//  BTArduinoImageScroll
//
//  Created by Chris Milne on 7/23/15.
//  Copyright (c) 2015 ideo. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;

typedef enum {
    LOGGING,
    RX,
    TX,
} ConsoleDataType;

@interface ViewController ()
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    UIImageView *imageView8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillMurray1024x768.jpg"]];
    
    [imageView setFrame:CGRectMake(imageView.frame.size.width*0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView2 setFrame:CGRectMake(imageView.frame.size.width*1, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView3 setFrame:CGRectMake(imageView.frame.size.width*2, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView4 setFrame:CGRectMake(imageView.frame.size.width*3, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView5 setFrame:CGRectMake(imageView.frame.size.width*4, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView6 setFrame:CGRectMake(imageView.frame.size.width*5, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView7 setFrame:CGRectMake(imageView.frame.size.width*6, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView8 setFrame:CGRectMake(imageView.frame.size.width*7, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
    [self.scrollView addSubview:imageView4];
    [self.scrollView addSubview:imageView5];
    [self.scrollView addSubview:imageView6];
    [self.scrollView addSubview:imageView7];
    [self.scrollView addSubview:imageView8];
    
    [self.scrollView setContentSize:CGSizeMake(imageView.frame.size.width*8, self.scrollView.frame.size.height)];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)sender {
    //NSLog(@"scrollViewDidScroll");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    long page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    NSLog(@"scrollViewDidEndScrollingAnimation. page: %ld", page);
    
    [self sendData:[NSString stringWithFormat:@"%ld", page]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Here is where we let the system know that we can switch the lights using BT using page as the input
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controls
- (IBAction)connectButtonPressed:(id)sender
{
    //[self.sendTextField resignFirstResponder];
    
    switch (self.state) {
        case IDLE:
            self.state = SCANNING;
            
            NSLog(@"Started scan ...");
            [self.connectButton setTitle:@"S" forState:UIControlStateNormal];
            
            [self.cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
            break;
            
        case SCANNING:
            self.state = IDLE;
            
            NSLog(@"Stopped scan");
            [self.connectButton setTitle:@"C" forState:UIControlStateNormal];
            
            [self.cm stopScan];
            break;
            
        case CONNECTED:
            NSLog(@"Disconnect peripheral %@", self.currentPeripheral.peripheral.name);
            [self.connectButton setTitle:@"*" forState:UIControlStateNormal];
            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
            break;
    }
}
/*
- (IBAction)sendTextFieldEditingDidBegin:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //    [self.tableView setContentOffset:CGPointMake(0, 220) animated:YES];
}

- (IBAction)sendTextFieldEditingChanged:(id)sender {
    if (self.sendTextField.text.length > 20)
    {
        [self.sendTextField setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [self.sendTextField setBackgroundColor:[UIColor whiteColor]];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self sendButtonPressed:textField];
    return YES;
}
 
- (IBAction)sendButtonPressed:(id)sender {
    
    [self.sendTextField resignFirstResponder];
    
    if (self.sendTextField.text.length == 0)
    {
        return;
    }
    
    [self addTextToConsole:self.sendTextField.text dataType:TX];
    [self.currentPeripheral writeString:self.sendTextField.text];
}
*/
 
-(void)sendData:(NSString*)dataString {
    NSLog(@"sending Data: %@", dataString);
    [self.currentPeripheral writeString:dataString];
}

#pragma mark - UARTPeripheralDelegate
 
- (void) didReadHardwareRevisionString:(NSString *)string
{
    [self addTextToConsole:[NSString stringWithFormat:@"Hardware revision: %@", string] dataType:LOGGING];
}

- (void) didReceiveData:(NSString *)string
{
    [self addTextToConsole:string dataType:RX];
}

- (void) addTextToConsole:(NSString *) string dataType:(ConsoleDataType) dataType
{
    NSString *direction;
    switch (dataType)
    {
        case RX:
            direction = @"RX";
            break;
            
        case TX:
            direction = @"TX";
            break;
            
        case LOGGING:
            direction = @"Log";
    }
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
    /*
    self.consoleTextView.text = [self.consoleTextView.text stringByAppendingFormat:@"[%@] %@: %@\n",[formatter stringFromDate:[NSDate date]], direction, string];
    
    [self.consoleTextView setScrollEnabled:NO];
    NSRange bottom = NSMakeRange(self.consoleTextView.text.length-1, self.consoleTextView.text.length);
    [self.consoleTextView scrollRangeToVisible:bottom];
    [self.consoleTextView setScrollEnabled:YES];
     */
}
 
#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.connectButton setEnabled:YES];
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [self.cm stopScan];
    
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    
    [self.cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Did connect peripheral %@", peripheral.name);
    
    
    //[self addTextToConsole:[NSString stringWithFormat:@"Did connect to %@", peripheral.name] dataType:LOGGING];
    
    self.state = CONNECTED;
    [self.connectButton setTitle:@"*" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:YES];
    //[self.sendTextField setUserInteractionEnabled:YES];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //[self addTextToConsole:[NSString stringWithFormat:@"Did disconnect from %@, error code %d", peripheral.name, error.code] dataType:LOGGING];
    
    self.state = IDLE;
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:NO];
    //[self.sendTextField setUserInteractionEnabled:NO];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
}

@end
