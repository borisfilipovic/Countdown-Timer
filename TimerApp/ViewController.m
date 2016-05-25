//
//  ViewController.m
//  TimerApp
//
//  Created by Boris Filipović on 10/14/14.
//  Copyright (c) 2014 Boris Filipović. All rights reserved.
//

#import "ViewController.h"
#import "TimeConverter.h"

int dynamicButtonCount = 0;

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Prevent sleep mode.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    // Prevent from app closing on it self.
    self.app = [UIApplication sharedApplication];

    // Create dictionary
    self.dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @false, @"Timer 1", // false = not on view, true = on view
                       @false, @"Timer 2",
                       @false, @"Timer 3",
                       @false, @"Timer 4",
                       nil];
    
    // Timers positions
    self.posDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @false, @"POS 1",
                       @false, @"POS 2",
                       @false, @"POS 3",
                       @false, @"POS 4",
                       nil];
    
    // Subscripe to "AppgoestoBackground notification message".
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Subscripe to "App comes from Background notification message".
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FromBackground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Detect orientation change.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDynamicButtonPressed:(UIButton *)sender {
    if(dynamicButtonCount < 4){
        
        dynamicButtonCount++;
        // Helper variables
        int currentButtonNumber = dynamicButtonCount;
        NSString *generateString = [[NSString alloc] init];
        
        // Check which Timer is not on view and is available
        for (int i = 1; i<=4; i++) {
             generateString = [NSString stringWithFormat:@"Timer %i", i];
            if([[self.dictionary objectForKey:generateString] isEqualToValue:@false]){
                currentButtonNumber = i;
                i = 5; // Get out of loop
            };
        }
        
        // Get width of screen.
        float framWidth = self.view.frame.size.width;
        
        // Start button
        UIButton *newDynamicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        newDynamicButton.tag = currentButtonNumber; // Set tag to button, so we can trace it
        newDynamicButton.frame = CGRectMake(0, 0, 100, 30);
        NSString *startButtonTitle = [NSString stringWithFormat:@"Start Timer %i", currentButtonNumber];
        [newDynamicButton setTitle:startButtonTitle forState:UIControlStateNormal];
        [newDynamicButton addTarget:self action:@selector(startTimer:) forControlEvents:UIControlEventTouchUpInside];
    
        // Stop button
        UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stopButton.tag = currentButtonNumber;
        stopButton.frame = CGRectMake(framWidth * 0.33, 0, 100, 30);
        NSString *stopButtonTitle = [NSString stringWithFormat:@"Stop Timer %i", currentButtonNumber];
        [stopButton setTitle:stopButtonTitle forState:UIControlStateNormal];
        [stopButton addTarget:self action:@selector(stopTimer:) forControlEvents:UIControlEventTouchUpInside];
        
        // Remove button.
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteButton.tag = currentButtonNumber;
        deleteButton.frame = CGRectMake(framWidth * 0.65, 0, 100, 30);
        NSString *deleteButtonTitle = [NSString stringWithFormat:@"Delete Timer %i", currentButtonNumber];
        [deleteButton setTitle:deleteButtonTitle forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteTimer:) forControlEvents:UIControlEventTouchUpInside];
        
        // Set animation.
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        // Create background view. It is initialized first, because other things will be on top of it.
        switch (currentButtonNumber) {
            case 1:
            {
                // Check if timerDisplayValu had any value before we terminated app. If so, than we should not override it.
                if(timerDisplayValue1 == 0){
                    timerDisplayValue1 = 0;
                }
                self.backgroundView1 = [[UIView alloc] init];
                self.backgroundView1.tag = currentButtonNumber;
                self.backgroundView1.backgroundColor = [UIColor greenColor];
                [self shiftTimerPositions:currentButtonNumber];
                [self.view addSubview:self.backgroundView1];
                
                // Create label
                self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 150, 40)];
                self.label1.tag = currentButtonNumber;
                self.label1.font = [UIFont fontWithName:@"Didot" size:30.0f];
                self.label1.text = @"0";
                
                // Set timer name.
                self.timerName1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, 80, 40)];
                self.timerName1.text = self.addTimerNameTextField.text;
                self.addTimerNameTextField.text = @""; // Clear text field.
                
                // Add subviews to background.
                [self.backgroundView1 addSubview:newDynamicButton];
                [self.backgroundView1 addSubview:stopButton];
                [self.backgroundView1 addSubview:deleteButton];
                [self.backgroundView1 addSubview:self.label1];
                [self.backgroundView1 addSubview:self.timerName1];
            }
                break;
            case 2:
            {
                // Check if timerDisplayValu had any value before we terminated app. If so, than we should not override it.
                if(timerDisplayValue2 == 0){
                    timerDisplayValue2 = 0;
                }
                self.backgroundView2 = [[UIView alloc] init];
                self.backgroundView2.tag = currentButtonNumber;
                [self shiftTimerPositions:currentButtonNumber];
                self.backgroundView2.backgroundColor = [UIColor yellowColor];
                
                // Update position dictionary.
                //[self.posDictionary setValue:@true forKey:@"Timer 2"];
                
                // Create label
                self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 100, 40)];
                self.label2.tag = currentButtonNumber;
                self.label2.font = [UIFont fontWithName:@"Didot" size:30.0f];
                self.label2.text = @"0";
                
                // Set timer name.
                self.timerName2 = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, 80, 40)];
                self.timerName2.text = self.addTimerNameTextField.text;
                self.addTimerNameTextField.text = @""; // Clear text field.
                
                [self.view addSubview:self.backgroundView2];
                // Add subviews to background.
                [self.backgroundView2 addSubview:newDynamicButton];
                [self.backgroundView2 addSubview:stopButton];
                [self.backgroundView2 addSubview:deleteButton];
                [self.backgroundView2 addSubview:self.label2];
                [self.backgroundView2 addSubview:self.timerName2];
            }
                break;
            case 3:
            {
                // Check if timerDisplayValu had any value before we terminated app. If so, than we should not override it.
                if(timerDisplayValue3 == 0){
                    timerDisplayValue3 = 0;
                }
                self.backgroundView3 = [[UIView alloc] init];
                self.backgroundView3.tag = currentButtonNumber;
                self.backgroundView3.backgroundColor = [UIColor lightGrayColor];
                [self shiftTimerPositions:currentButtonNumber];
                [self.view addSubview:self.backgroundView3];
                
                // Update position dictionary.
                //[self.posDictionary setValue:@true forKey:@"Timer 3"];
                
                // Create label
                self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 100, 40)];
                self.label3.tag = currentButtonNumber;
                self.label3.font = [UIFont fontWithName:@"Didot" size:30.0f];
                self.label3.text = @"0";
                
                // Set timer name
                self.timerName3 = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, 80, 40)];
                self.timerName3.text = self.addTimerNameTextField.text;
                self.addTimerNameTextField.text = @""; // Clear text field.
                
                // Add subviews to background.
                [self.backgroundView3 addSubview:newDynamicButton];
                [self.backgroundView3 addSubview:stopButton];
                [self.backgroundView3 addSubview:deleteButton];
                [self.backgroundView3 addSubview:self.label3];
                [self.backgroundView3 addSubview:self.timerName3];
            }
                break;
            case 4:
            {
                // Check if timerDisplayValu had any value before we terminated app. If so, than we should not override it.
                if(timerDisplayValue4 == 0){
                    timerDisplayValue4 = 0;
                }
                self.backgroundView4 = [[UIView alloc] init];
                self.backgroundView4.tag = currentButtonNumber;
                self.backgroundView4.backgroundColor = [UIColor purpleColor];
                [self shiftTimerPositions:currentButtonNumber];
                [self.view addSubview:self.backgroundView4];
                
                // Update position dictionary.
                //[self.posDictionary setValue:@true forKey:@"Timer 4"];
                
                // Create label
                self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 100, 40)];
                self.label4.tag = currentButtonNumber;
                self.label4.font = [UIFont fontWithName:@"Didot" size:30.0f];
                self.label4.text = @"0";
                
                // Set timer name.
                self.timerName4 = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, 80, 40)];
                self.timerName4.text = self.addTimerNameTextField.text;
                self.addTimerNameTextField.text = @""; // Clear text field.
                
                // Add subviews to background.
                [self.backgroundView4 addSubview:newDynamicButton];
                [self.backgroundView4 addSubview:stopButton];
                [self.backgroundView4 addSubview:deleteButton];
                [self.backgroundView4 addSubview:self.label4];
                [self.backgroundView4 addSubview:self.timerName4];
            }
                break;
            default:
                break;
        }
        
        // Change dictionary value to true - it is on view
        [self.dictionary setValue:@true forKey:generateString];
        
        // If all buttons on screen prevent from adding more buttons
        if (dynamicButtonCount == 4) {
            self.addTimerButton.hidden = YES;
        } else if (dynamicButtonCount < 4){
            self.addTimerButton.hidden = NO;
        }
    }
}

-(void)shiftTimerPositions:(int)paramTag
{
    int positionY = 65; // Starting value.
    if ([[self.dictionary valueForKey:@"Timer 1"] isEqualToValue:@false] && paramTag == 1) {
        
        [self.backgroundView1 setFrame:CGRectMake(2, positionY, 0, 0)];

        // Update position dictionary.
        [self.dictionary setValue:@true forKey:@"Timer 1"];
        
        // Re-arange position.
        [self rearangeTimerPositions];
        
        positionY += 100;
        
    } else {
        positionY += 100;
    }
    
    if ([[self.dictionary valueForKey:@"Timer 2"] isEqualToValue:@false] && paramTag == 2) {
        
        [self.backgroundView2 setFrame:CGRectMake(2, positionY, 315, 50)];
        
        // Update position dictionary.
        [self.dictionary setValue:@true forKey:@"Timer 2"];
        
        // Re-arange position.
        [self rearangeTimerPositions];
        positionY += 100;
        
    } else {
        positionY += 100;
    }
    
    if ([[self.dictionary valueForKey:@"Timer 3"] isEqualToValue:@false] && paramTag == 3) {
        
        [self.backgroundView3 setFrame:CGRectMake(2, positionY, 315, 50)];
        
        // Update position dictionary.
        [self.dictionary setValue:@true forKey:@"Timer 3"];
        
        // Re-arange position
        [self rearangeTimerPositions];
        
        positionY += 100;
        
    } else {
        positionY += 100;
    }
    
    if ([[self.dictionary valueForKey:@"Timer 4"] isEqualToValue:@false] && paramTag == 4) {
        
        [self.backgroundView4 setFrame:CGRectMake(2, positionY, 315, 50)];
        
        // Update position dictionary.
        [self.dictionary setValue:@true forKey:@"Timer 4"];
        
        // Re-arange position
        [self rearangeTimerPositions];
        
        positionY += 100;
    }
}

-(void)rearangeTimerPositions
{
    int positionY = 65; // Starting value.
    
    if ([[self.dictionary valueForKey:@"Timer 1"] isEqualToValue:@true]) {
        [self.backgroundView1 setFrame:CGRectMake(4, positionY, self.view.frame.size.width - 8, 85)];
        positionY += 100;
    }
        
    if ([[self.dictionary valueForKey:@"Timer 2"] isEqualToValue:@true]) {
        [self.backgroundView2 setFrame:CGRectMake(4, positionY, self.view.frame.size.width - 8, 85)];
        positionY += 100;
    }
        
    if ([[self.dictionary valueForKey:@"Timer 3"] isEqualToValue:@true]) {
        [self.backgroundView3 setFrame:CGRectMake(4, positionY, self.view.frame.size.width - 8, 85)];
        positionY += 100;
    }
        
    if ([[self.dictionary valueForKey:@"Timer 4"] isEqualToValue:@true]) {
        [self.backgroundView4 setFrame:CGRectMake(4, positionY, self.view.frame.size.width - 8, 85)];
        positionY += 100;
    }
}

-(void)startTimer:(UIButton *)paramSender
{
    // Set YES to prevent device going into sleep because of no touch inputs while timer is running.
    if (!self.app.isIdleTimerDisabled) {
        [self.app setIdleTimerDisabled:YES];
    }
    
    if ([paramSender.titleLabel.text isEqualToString:@"Start Timer 1"] && !self.timer1.isValid) {
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:paramSender.titleLabel.text repeats:YES];
    } else if ([paramSender.titleLabel.text isEqualToString:@"Start Timer 2"] && !self.timer2.isValid){
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:paramSender.titleLabel.text repeats:YES];
    } else if ([paramSender.titleLabel.text isEqualToString:@"Start Timer 3"] && !self.timer3.isValid){
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:paramSender.titleLabel.text repeats:YES];
    } else if ([paramSender.titleLabel.text isEqualToString:@"Start Timer 4"] && !self.timer4.isValid){
        self.timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:paramSender.titleLabel.text repeats:YES];
    }
}

-(void)stopTimer:(UIButton *)paramButton
{
    
    if([paramButton.titleLabel.text isEqualToString:@"Stop Timer 1"] && self.timer1.isValid){
        [self.timer1 invalidate];
        self.label1.text = @"0";
        timerDisplayValue1 = 0;
    } else if ([paramButton.titleLabel.text isEqualToString:@"Stop Timer 2"] && self.timer2.isValid){
        [self.timer2 invalidate];
        self.label2.text = @"0";
        timerDisplayValue2 = 0;
    } else if ([paramButton.titleLabel.text isEqualToString:@"Stop Timer 3"] && self.timer3.isValid){
        [self.timer3 invalidate];
        self.label3.text = @"0";
        timerDisplayValue3 = 0;
    } else if ([paramButton.titleLabel.text isEqualToString:@"Stop Timer 4"] && self.timer4.isValid){
        [self.timer4 invalidate];
        self.label4.text = @"0";
        timerDisplayValue4 = 0;
    }
    
    // If all off timers are off then app should go to "sleep" mode.
    if (!(self.timer1.isValid) && !(self.timer2.isValid) && !(self.timer3.isValid) && !(self.timer4.isValid)) {
        if (self.app.isIdleTimerDisabled) {
            [self.app setIdleTimerDisabled:NO];
        }
    }
}

-(void)deleteTimer:(UIButton *)paramButton
{
    // Remove buttons from screen. (we have 4 objects in our view)
    for (int i = 0; i < 5; i++) {
        [[self.view viewWithTag:paramButton.tag] removeFromSuperview];
    }
    
    // Stop timer if running
    paramButton.titleLabel.text = [NSString stringWithFormat:@"Stop Timer %li", (long)paramButton.tag];
    [self stopTimer:paramButton];
    
    // Decrese timers on view count by 1.
    dynamicButtonCount--;
    
    // Show add Timer button
    if (dynamicButtonCount < 4) {
        self.addTimerButton.hidden = NO;
    }
    
    // Update Dictionary that this button is now available
    [self.dictionary setValue:@false forKey:[NSString stringWithFormat:@"Timer %li", (long)paramButton.tag]];
    
    // Re-arange view
    [self rearangeTimerPositions];
}

-(void)handleTimer:(NSTimer *)paramSender
{
    // Create instance of TimeConverter class.
    TimeConverter *timeConverter = [[TimeConverter alloc] init];
    
    if([paramSender.userInfo isEqualToString:@"Start Timer 1"]){
        timerDisplayValue1++;
        self.label1.text = [timeConverter convertTime:timerDisplayValue1];
    
        if(self.label1.isHidden){
            self.label1.hidden = NO;
        }
        
    } else if([paramSender.userInfo isEqualToString:@"Start Timer 2"]){
        timerDisplayValue2++;
        self.label2.text = [timeConverter convertTime:timerDisplayValue2];
        
        if(self.label2.isHidden){
            self.label2.hidden = NO;
        }
        
    } else if([paramSender.userInfo isEqualToString:@"Start Timer 3"]){
        timerDisplayValue3++;
        self.label3.text = [timeConverter convertTime:timerDisplayValue3];
        
        if(self.label3.isHidden){
            self.label3.hidden = NO;
        }
        
    } else if([paramSender.userInfo isEqualToString:@"Start Timer 4"]){
        timerDisplayValue4++;
        self.label4.text = [timeConverter convertTime:timerDisplayValue4];
        
        if(self.label4.isHidden){
            self.label4.hidden = NO;
        }
        
    }
    
    // Remove object.
    timeConverter = nil;

}

- (IBAction)addCounterButton:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is alert view" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Application goes to background.

-(void)goBackground
{
    // Save additional data.
    self.saveData = [NSUserDefaults standardUserDefaults];
    BOOL isOpen;
    NSString *tmpKey;
    for (int i = 1; i <= [self.dictionary count]; i++) {
        tmpKey = [NSString stringWithFormat:@"Timer %i", i];
        isOpen = [[self.dictionary valueForKey:tmpKey] isEqualToValue:@true];
        [self.saveData setInteger:isOpen forKey:[NSString stringWithFormat:@"Timer%iOpen",i]];
    }
    
    // Save data before app goes to background.
    [self saveCurrentTimerValues];
}


-(NSString *)isOpened:(int)param
{
    // Some code here.
    if(param == 1){
        //NSLog(@"Timer pa je %i", timerDisplayValue1);
        return (timerDisplayValue1 > 0) ? @"true" : @"false";
    } else if (param == 2){
        //NSLog(@"Timer pa je %i", timerDisplayValue2);
        return (timerDisplayValue2 > 0) ? @"true" : @"false";
    } else if (param == 3){
        //NSLog(@"Timer pa je %i", timerDisplayValue3);
        return (timerDisplayValue3 > 0) ? @"true" : @"false";
    } else if (param == 4){
        //NSLog(@"Timer pa je %i", timerDisplayValue4);
        return (timerDisplayValue4 > 0) ? @"true" : @"false";
    }
    
    return 0;
}

#pragma mark - Applications becomes active.

-(void)FromBackground
{
    // Read Data from NSUserDefaults.
    self.saveData = [NSUserDefaults standardUserDefaults];
    timerDisplayValue1 = [self.saveData integerForKey:@"Timer1"];
    timerDisplayValue2 = [self.saveData integerForKey:@"Timer2"];
    timerDisplayValue3 = [self.saveData integerForKey:@"Timer3"];
    timerDisplayValue4 = [self.saveData integerForKey:@"Timer4"];
    NSDate *goingToBackgroundDate = [self.saveData objectForKey:@"Date"];
    
    // Calculate time that passed since app went to background.
    NSDate *tmpDate = [[NSDate alloc]init];
    
    // Difference between reciever (tmpDate) and another(older date)goingToBackgroundDate.
    timeSinceGoingIntoBackground = [tmpDate timeIntervalSinceDate:goingToBackgroundDate];
    
    if (timerDisplayValue1 > 0) {
        // Add passed timeinterval to new value.
        timerDisplayValue1 += timeSinceGoingIntoBackground;
        
        // Check if timer was closed.
        BOOL wasOpened = [self.saveData boolForKey:@"Timer1Open"];
        if(wasOpened){
            // It means that it was opened and then close when app terminate. So lets open it again.
            [self addDynamicButtonPressed:nil];
        }
        
        // Start timer again.
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:@"Start Timer 1" repeats:YES];
    } else{
        // Show label.
        self.label1.hidden = NO;
    }
    
    if (timerDisplayValue2 > 0) {
        // Add passed timeinterval to new value.
        timerDisplayValue2 += timeSinceGoingIntoBackground;
        
        // Check if timer was closed.
        BOOL wasOpened = [self.saveData boolForKey:@"Timer2Open"];
        if(wasOpened){
            // It means that it was opened and then close when app terminate. So lets open it again.
            [self addDynamicButtonPressed:nil];
        }

        // Start timer again.
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:@"Start Timer 2" repeats:YES];
    } else{
        // Show label.
        self.label2.hidden = NO;
    }
    
    if (timerDisplayValue3 > 0) {
        // Add passed timeinterval to new value.
        timerDisplayValue3 += timeSinceGoingIntoBackground;
        
        // Check if timer was closed.
        BOOL wasOpened = [self.saveData boolForKey:@"Timer3Open"];
        if(wasOpened){
            // It means that it was opened and then close when app terminate. So lets open it again.
            [self addDynamicButtonPressed:nil];
        }        
        
        // Start timer again.
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:@"Start Timer 3" repeats:YES];
    } else{
        // Show label.
        self.label3.hidden = NO;
    }
    
    if (timerDisplayValue4 > 0) {
        // Add passed timeinterval to new value.
        timerDisplayValue4 += timeSinceGoingIntoBackground;
        
        // Check if timer was closed.
        BOOL wasOpened = [self.saveData boolForKey:@"Timer4Open"];
        if(wasOpened){
            // It means that it was opened and then close when app terminate. So lets open it again.
            [self addDynamicButtonPressed:nil];
        }
        
        
        // Start timer again.
        self.timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleTimer:) userInfo:@"Start Timer 4" repeats:YES];
    } else{
        // Show label.
        self.label4.hidden = NO;
    }
}

#pragma mark - Orientation Change
-(void)didChangeOrientation
{
    // Re-arange timer positions when orientation is changed.
    [self rearangeTimerPositions];
}

#pragma mark - Save current timer values
-(void)saveCurrentTimerValues
{
    // Save data before app goes to background.
    self.saveData = [NSUserDefaults standardUserDefaults];
    [self.saveData setInteger:timerDisplayValue1 forKey:@"Timer1"]; // Save data.
    [self.saveData setInteger:timerDisplayValue2 forKey:@"Timer2"];
    [self.saveData setInteger:timerDisplayValue3 forKey:@"Timer3"];
    [self.saveData setInteger:timerDisplayValue4 forKey:@"Timer4"];
    
    self.date = [NSDate date];
    [self.saveData setObject:self.date forKey:@"Date"]; // Save date/Time.
    [self.saveData synchronize]; // Synchronise data.
    
    // Set values to 0.
    timerDisplayValue1 = 0;
    timerDisplayValue2 = 0;
    timerDisplayValue3 = 0;
    timerDisplayValue4 = 0;
    
    // Invalidate timers.
    if(self.timer1.isValid){
        [self.timer1 invalidate];
    }
    
    if(self.timer2.isValid){
        [self.timer2 invalidate];
    }
    
    if(self.timer3.isValid){
        [self.timer3 invalidate];
    }
    
    if(self.timer4.isValid){
        [self.timer4 invalidate];
    }
    
    // Hide labels, so they don't show wrong time at first.
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.label4.hidden = YES;
}
@end