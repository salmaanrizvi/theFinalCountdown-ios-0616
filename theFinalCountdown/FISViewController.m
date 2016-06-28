//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *timeDisplay;
@property (strong, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (nonatomic) BOOL hasTimerStarted;
@property (strong, nonatomic) NSTimer *countdownTimer;
@property (nonatomic) NSInteger setTime;
@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasTimerStarted = NO;
    self.timeDisplay.hidden = YES;
    self.pauseButton.hidden = NO;
    self.startStopButton.titleLabel.text = @"Stop";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{


}

- (IBAction)startStopTapped:(id)sender {
    
    if(self.hasTimerStarted == NO) {
        
        self.setTime = self.datePicker.countDownDuration;
        [self setTimeDisplayWithSeconds:self.setTime];
        self.datePicker.hidden = YES;
        self.hasTimerStarted = YES;
        self.pauseButton.enabled = YES;
        [self.startStopButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        self.countdownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    }
    else {
        [self.countdownTimer invalidate];
        self.timeDisplay.hidden = YES;
        self.datePicker.hidden = NO;
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        self.hasTimerStarted = NO;
        self.pauseButton.enabled = NO;
    }
}

-(void)timerTick:(NSTimer *)timer {
    self.setTime -= 1;
    [self setTimeDisplayWithSeconds:self.setTime];
}
                               
-(NSInteger)setTimeDisplayWithSeconds:(NSInteger)timeInSeconds {
    
    NSInteger hours = timeInSeconds / (60 * 60);
    NSInteger minutes = (timeInSeconds / 60) - 60*hours;
    NSInteger seconds = timeInSeconds - hours*60*60 - minutes*60;
    
    if(hours > 0) {
        self.timeDisplay.text = [NSString stringWithFormat:@"%02li:%02li:%02li", hours, minutes, seconds];
    }
    else {
        self.timeDisplay.text = [NSString stringWithFormat:@"%02li:%02li", minutes, seconds];
    }
    
    self.timeDisplay.hidden = NO;
    self.timeDisplay.adjustsFontSizeToFitWidth = YES;
    return timeInSeconds;
}

- (IBAction)pauseButtonTapped:(id)sender {
    if (self.hasTimerStarted) { // timer was running when pause was hit
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        self.hasTimerStarted = NO;
        [self.countdownTimer invalidate];
    }
    else {
        self.hasTimerStarted = YES;
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self setTimeDisplayWithSeconds:self.setTime];
        self.countdownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
