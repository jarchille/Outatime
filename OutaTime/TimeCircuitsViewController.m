//
//  TimeCircuitsViewController.m
//  OutaTime
//
//  Created by Ben Gohlke on 2/12/15.
//  Copyright (c) 2015 The Iron Yard. All rights reserved.
//

#import "TimeCircuitsViewController.h"
#import "DatePickerViewController.h"

@interface TimeCircuitsViewController ()

//
// 1. We need three properties to hold various info.
//    One should be an NSTimer object to use when counting up the speedometer label.
//    Another should be an NSDateFormatter object to use to format the dates for the time circuit readouts.
//    The last is an NSInteger object to hold the current speed of the DeLorean.
//

// These are the properties that will be wired up to the labels in the storyboard. If the circles to the left of them are hollow, they have not been connected in the storyboard.
@property (weak, nonatomic) IBOutlet UILabel *destinationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeDepartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSTimer *timer;
@property (assign) NSInteger currentSpeed;



// This is an IBAction. It is a method that will fire when the element it's connected to fires an event of your choosing.
- (IBAction)travelBack:(UIButton *)sender;

// These are private custom methods
- (void)startTimer;
- (void)stopTimer;
- (void)updateSpeed;

@end

@implementation TimeCircuitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.currentSpeed = 0;
    
    // 4. Once created, the formatString you see below needs to be set as the date formatter's dateFormat
    //
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMddyyyy"
                                                             options:0
                                                              locale:[NSLocale currentLocale]];
    
    self.dateFormatter.dateFormat = formatString;
    
    //
    // 5. The presentTimeLabel needs to be set to today's date. Use the dateFormatter object to do this.
    //
    NSDate *date = [NSDate init];
    self.presentTimeLabel.text = [self.dateFormatter stringFromDate:date];
    
    //
    // 6. The currentSpeed integer object needs to be set to 0 to start.
    self.currentSpeed = 0;

    
    //
    // 7. The speedLabel should be set to "% MPH", with the % being the current speed
    self.speed.text = [NSString stringWithFormat:@"%ld MPH", (long)self.currentSpeed];

    
    //
    // 8. The lastTimeDeparted label needs to be set to "--- -- ----"
    self.lastTimeDepartedLabel.text = @"--- -- ----";
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDestinationDatePickerSegue"])
    {
        DatePickerViewController *timePickerVC = [segue destinationViewController];
        //
        // 10. This view controller needs to be set as the time picker view controller's delegate object.
        timePickerVC.delegate = self;
        
    }
}

#pragma mark - TimeCircuitsDatePickerDelegate

- (void)destinationDateWasChosen:(NSDate *)destinationDate
{
    //
    // 12. The destinationTimeLabel needs to be set to the destination date using our date formatter object
    self.destinationTimeLabel.text = [self.dateFormatter stringFromDate:destinationDate];
}

#pragma mark - Action Handlers

- (IBAction)travelBack:(UIButton *)sender
{
    //
    // 13. This is where we will start counting the speedometer up to 88 MPH. We need to use the timer object to do that. Is
    //    there a method defined that will allow us to get the timer started?
    [self.timer fire];

}

#pragma mark - Private

- (void)startTimer
{
    //
    // 14. We need to check that the timer object isn't running, and the best way to do that is just to check if the timer
    //    object has been instantiated, or in this case, NOT instantiated.
    //
    if (!self.timer)
    {
        //
        // 15. Below is an example of a timer being instantiated with a particular interval and firing a particular
        //    method each time the time interval has elapsed. Use this to instantiate your timer for 0.1 sec intervals. It
        //    will need to fire our custom method to update the speed label.
        //
        
   NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        
    }
}

- (void)stopTimer
{
    //
    // 16. We need to stop the timer object here. The method to call is called "invalidate".
    //    Once it's stopped, we want to nil out the object so we can create a new one when the user asks to travel back
    //    again.
    [self.timer invalidate];
    self.timer = nil;

    
}

- (void)updateSpeed
{
    //
    // 17. We need to check if the current speed variable is set to 88 yet.
    //
    if (self.currentSpeed != 88)
    {
        //
        // 18. If it's not yet set to 88, we want to increment the current speed variable by 1.
        self.currentSpeed = self.currentSpeed + 1;
        
        //
        // 19. Here we want to update the speed label to reflect the current speed.
        self.speed.text = [NSString stringWithFormat:@"%ld M.P.H", (long)self.currentSpeed];
    }
    else
    {
        //
        // 20. If the speed variable is at least 88, we want to stop the timer here.
        [self.timer invalidate];
        self.timer = nil;

        //
        // 21. Then we need to update the lastTimeDepartedLabel with the value of the presentTimeLabel.
        self.lastTimeDepartedLabel.text = self.presentTimeLabel.text;

        //
        // 22. The presentTimeLabel needs to take the value of the destinationTimeLabel here.
        self.presentTimeLabel.text = self.destinationTimeLabel.text;
        
        //
        // 23. Lastly, we need to reset the current speed label to 0 here.
        self.speed.text = [NSString stringWithFormat:@"0 M.P.H"];
        
    }
}

@end
