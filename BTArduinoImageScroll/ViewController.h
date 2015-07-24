//
//  ViewController.h
//  BTArduinoImageScroll
//
//  Created by Chris Milne on 7/23/15.
//  Copyright (c) 2015 ideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"

@interface ViewController : UIViewController<UIScrollViewDelegate, CBCentralManagerDelegate, UARTPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

