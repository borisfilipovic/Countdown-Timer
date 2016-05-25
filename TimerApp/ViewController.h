//
//  ViewController.h
//  TimerApp
//
//  Created by Boris Filipović on 10/14/14.
//  Copyright (c) 2014 Boris Filipović. All rights reserved.
//

#import <UIKit/UIKit.h>

// Display timer values to screen.
int timerDisplayValue1;
int timerDisplayValue2;
int timerDisplayValue3;
int timerDisplayValue4;

// Time that app have been in background.
int timeSinceGoingIntoBackground;

@interface ViewController : UIViewController

- (IBAction)addDynamicButtonPressed:(UIButton *)sender;
- (IBAction)addCounterButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *addTimerButton;
@property (weak, nonatomic) IBOutlet UITextField *addTimerNameTextField;

// Timers.
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;
@property (strong, nonatomic) NSTimer *timer3;
@property (strong, nonatomic) NSTimer *timer4;

// Dictionary.
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *posDictionary;

// Background View.
@property (strong, nonatomic) UIView *backgroundView1;
@property (strong, nonatomic) UIView *backgroundView2;
@property (strong, nonatomic) UIView *backgroundView3;
@property (strong, nonatomic) UIView *backgroundView4;

// Label.
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;

// Timer name.
@property (strong, nonatomic) UILabel *timerName1;
@property (strong, nonatomic) UILabel *timerName2;
@property (strong, nonatomic) UILabel *timerName3;
@property (strong, nonatomic) UILabel *timerName4;

// Application singleton.
@property (strong, nonatomic) UIApplication *app;

// Save data to NSUserDefaults.
@property (strong, nonatomic) NSUserDefaults *saveData;

// Date property.
@property (strong, nonatomic) NSDate *date;

@end

