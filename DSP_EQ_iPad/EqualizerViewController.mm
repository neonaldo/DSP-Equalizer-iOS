//
//  EqualizerViewController.m
//  DSP_EQ_iPad
//
//  Created by Joey La Barck on 4/29/14.
//  Copyright (c) 2014 Joey La Barck. All rights reserved.
//

#import "EqualizerViewController.h"
#import <iostream>

@interface EqualizerViewController ()

@end

@implementation EqualizerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Setup App Delegate
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Set Initial compare level
    compareLevel = 0.0f;
    
    _songPicker.delegate = self;
    _songPicker.dataSource = self;
    
    
    //Set Background Color
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    //Create Songs
    titleArray = [[NSArray alloc] initWithObjects:@"Runaway",@"99 Red Balloons", @"Paradise", nil];
    
    //Create Frame for particle emitter
    CGRect vFrame = _visualize.frame;
    vFrame.origin.x = 20.0;
    vFrame.origin.y = 75.0;
    vFrame.size.height = 250;
    vFrame.size.width = 985;
    _visualize.frame = vFrame;
    
    //More Setup
    _visualize.backgroundColor = [UIColor clearColor];
    self.visualizer = [[visualizerView alloc] initWithFrame:vFrame];
    //[_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_visualize addSubview:_visualizer];
    
    //Setup sliders color to green
    _slider_1.tintColor = [UIColor cyanColor];
    _slider_2.tintColor = [UIColor cyanColor];
    _slider_3.tintColor = [UIColor cyanColor];
    _slider_4.tintColor = [UIColor cyanColor];
    _slider_5.tintColor = [UIColor cyanColor];
    _slider_6.tintColor = [UIColor cyanColor];
    _slider_7.tintColor = [UIColor cyanColor];
    _slider_8.tintColor = [UIColor cyanColor];
    _slider_9.tintColor = [UIColor cyanColor];
    _slider_10.tintColor = [UIColor cyanColor];
    _slider_11.tintColor = [UIColor cyanColor];
    _slider_12.tintColor = [UIColor cyanColor];
    _slider_13.tintColor = [UIColor cyanColor];
    _slider_14.tintColor = [UIColor cyanColor];
    _slider_15.tintColor = [UIColor cyanColor];
    
    //Change text color of band labels
    _band1.textColor = [UIColor whiteColor];
    _band2.textColor = [UIColor whiteColor];
    _band3.textColor = [UIColor whiteColor];
    _band4.textColor = [UIColor whiteColor];
    _band5.textColor = [UIColor whiteColor];
    _band6.textColor = [UIColor whiteColor];
    _band7.textColor = [UIColor whiteColor];
    _band8.textColor = [UIColor whiteColor];
    _band9.textColor = [UIColor whiteColor];
    _band10.textColor = [UIColor whiteColor];
    _band11.textColor = [UIColor whiteColor];
    _band12.textColor = [UIColor whiteColor];
    _band13.textColor = [UIColor whiteColor];
    _band14.textColor = [UIColor whiteColor];
    _band15.textColor = [UIColor whiteColor];
    
    //Change Color of Current Gain labels
    _current1.textColor = [UIColor whiteColor];
    _current2.textColor = [UIColor whiteColor];
    _current3.textColor = [UIColor whiteColor];
    _current4.textColor = [UIColor whiteColor];
    _current5.textColor = [UIColor whiteColor];
    _current6.textColor = [UIColor whiteColor];
    _current7.textColor = [UIColor whiteColor];
    _current8.textColor = [UIColor whiteColor];
    _current9.textColor = [UIColor whiteColor];
    _current10.textColor = [UIColor whiteColor];
    _current11.textColor = [UIColor whiteColor];
    _current12.textColor = [UIColor whiteColor];
    _current13.textColor = [UIColor whiteColor];
    _current14.textColor = [UIColor whiteColor];
    _current15.textColor = [UIColor whiteColor];
    
    //Redraw bass,mid,treble sliders
    CGRect bassFrame = _bassSlider.frame;
    bassFrame.origin.y = 335.0;
    bassFrame.origin.x = 60.0;
    bassFrame.size.width = 250.0;
    _bassSlider.frame = bassFrame;
    _bassSlider.tintColor = [UIColor cyanColor];
    _bassSlider.maximumValue = 20.0;
    _bassSlider.minimumValue = -20.0;
    [_bassSlider setValue:0.0];
    
    bassFrame.origin.x = 370.0;
    _midSlider.frame = bassFrame;
    _midSlider.tintColor = [UIColor cyanColor];
    _midSlider.maximumValue = 20.0;
    _midSlider.minimumValue = -20.0;
    [_midSlider setValue:0.0];
    
    bassFrame.origin.x = 680.0;
    _trebleSlider.frame = bassFrame;
    _trebleSlider.tintColor = [UIColor cyanColor];
    _trebleSlider.maximumValue = 20.0;
    _trebleSlider.minimumValue = -20.0;
    [_trebleSlider setValue:0.0];
    
    //Redraw labels
    [_bassLabel setTextColor:[UIColor whiteColor]];
    [_bassLabel setText:@"Bass"];
    [_midLabel setTextColor:[UIColor whiteColor]];
    [_midLabel setText:@"Mid"];
    [_trebleLabel setTextColor:[UIColor whiteColor]];
    [_trebleLabel setText:@"Treble"];
    
    CGRect labelFrame = _bassLabel.frame;
    labelFrame.origin.y = 315.0;
    labelFrame.origin.x = 60.0;
    labelFrame.size.width = 100.0;
    _bassLabel.frame = labelFrame;
    
    labelFrame.origin.x = 370.0;
    _midLabel.frame = labelFrame;
    
    labelFrame.origin.x = 680.0;
    _trebleLabel.frame = labelFrame;
    
    //Redraw Sliders vertically
    [self drawSlidersVertical];
    
    //Redraw BandLabels
    [self drawBands];
    
    //Redraw Current DB Labels
    [self drawDBwithOffset:25.0];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //Setup buffer and audio manager
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    //Corner Label Color
    _display.textColor = [UIColor whiteColor];
    
    // define center frequencies of the bands
    float centerFrequencies[15];
    centerFrequencies[0] = 25.0f;
    centerFrequencies[1] = 40.0f;
    centerFrequencies[2] = 63.0f;
    centerFrequencies[3] = 100.0f;
    centerFrequencies[4] = 160.0f;
    centerFrequencies[5] = 250.0f;
    centerFrequencies[6] = 400.0f;
    centerFrequencies[7] = 630.0f;
    centerFrequencies[8] = 1000.0f;
    centerFrequencies[9] = 1500.0f;
    centerFrequencies[10] = 2500.0f;
    centerFrequencies[11] = 4000.0f;
    centerFrequencies[12] = 6300.0f;
    centerFrequencies[13] = 10000.0f;
    centerFrequencies[14] = 16000.0f;
        
    //Static Labels
    _band1.text = @"25Hz";
    _band2.text = @"40Hz";
    _band3.text = @"63Hz";
    _band4.text = @"100Hz";
    _band5.text = @"160Hz";
    _band6.text = @"250Hz";
    _band7.text = @"400Hz";
    _band8.text = @"630Hz";
    _band9.text = @"1kHz";
    _band10.text = @"1.5kHz";
    _band11.text = @"2.5kHz";
    _band12.text = @"4kHz";
    _band13.text = @"6.3kHz";
    _band14.text = @"10kHz";
    _band15.text = @"16kHz";

    // define Q factor of the bands
    QFactor = 2.0f;
    
    // define initial gain
    initialGain = 0.0f;
    
    //Labels for current gain
    _current1.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current2.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current3.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current4.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current5.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current6.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current7.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current8.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current9.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current10.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current11.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current12.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current13.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current14.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    _current15.text = [NSString stringWithFormat:@"%idB",(int)initialGain];
    
    //Align labels
    _band1.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band2.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band3.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band4.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band5.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band6.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band7.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band8.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band9.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band10.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band11.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band12.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band13.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band14.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    _band15.textAlignment = NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment);
    
    // init PeakingFilters
    for (int i = 0; i < 15; i++)
    {
        PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:samplingRate];
        PEQ[i].Q = QFactor;
        PEQ[i].centerFrequency = centerFrequencies[i];
        PEQ[i].G = initialGain;
    }
    
    // init SoundLevelMeters
    outputWatcher = [[NVSoundLevelMeter alloc] init];
   
}

- (void)waveletFilterInitialize {
    //Setup Audio Manager Through Novocaine
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    //Set Up Low Pass Filter 1
    LPF1 = [[NVLowpassFilter alloc] initWithSamplingRate:samplingRate]; //Initialize
    LPF1.Q = 2.0f;                                                      //Define Q Factor
    LPF1.cornerFrequency = 11000.0f;                                    //Define Corner Frequency
}

- (void)quickUpdate{
    _display.text = [NSString stringWithFormat:@"%f", _level];
    //[_visualize setAlpha:abs(_level)/100.0f];
    
    //Gets latest _level
    EqualizerAppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    _level = [appDel getLevel];
    
    if (abs(compareLevel - _level) > 0.5)
    {
        NSLog(@"Beat");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [_visualize setAlpha:2.00f];
        _display.textColor = [UIColor cyanColor];
        [UIView commitAnimations];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_visualize setAlpha:0.25f];
    _display.textColor = [UIColor whiteColor];
    [UIView commitAnimations];
    
    compareLevel = _level;

}

- (void)updateViewFromLevel:(float)level{
    if (level < -40 && level > -50)
    {
        NSLog(@"Level 1");
        _display.text = @"Level 1";
    }
    else if (level < -30 && level > -40)
    {
        NSLog(@"Level 2");
        _display.text = @"Level 2";
    }
    else if (level < -20 && level > -30)
    {
        _display.text = @"Level 3";
    }
    else if (level < -10 && level > -20)
    {
        NSLog(@"Level 4");
        _display.text = @"Level 4";
    }
    else if (level < 0 && level > -10)
    {
        NSLog(@"Level 5");
        _display.text = @"Level 5";
    }
    else if (level < 10 && level > 0)
    {
        NSLog(@"Level 6");
        _display.text = @"Level 6";
    }
    else if (level < 20 && level > 10)
    {
        NSLog(@"Level 7");
        _display.text = @"Level 7";
    }
    else if (level < 30 && level > 20)
    {
        NSLog(@"Level 8");
        _display.text = @"Level 8";
    }
}

- (void)drawSlidersVertical{   //Redraw Sliders vertically
    CGRect sliderFrame = _slider_1.frame;
    
    //Slider 1 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0;
    sliderFrame.origin.y = 550;
    _slider_1.frame = sliderFrame;
    _slider_1.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_1.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 2 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60;
    sliderFrame.origin.y = 550;
    _slider_2.frame = sliderFrame;
    _slider_2.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_2.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 3 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60;
    sliderFrame.origin.y = 550;
    _slider_3.frame = sliderFrame;
    _slider_3.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_3.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 4 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_4.frame = sliderFrame;
    _slider_4.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_4.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 5 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_5.frame = sliderFrame;
    _slider_5.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_5.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 6 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_6.frame = sliderFrame;
    _slider_6.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_6.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 7 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_7.frame = sliderFrame;
    _slider_7.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_7.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 8 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_8.frame = sliderFrame;
    _slider_8.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_8.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 9 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_9.frame = sliderFrame;
    _slider_9.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_9.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 10 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_10.frame = sliderFrame;
    _slider_10.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_10.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 11 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_11.frame = sliderFrame;
    _slider_11.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_11.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 12 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_12.frame = sliderFrame;
    _slider_12.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_12.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 13 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_13.frame = sliderFrame;
    _slider_13.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_13.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 14 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_14.frame = sliderFrame;
    _slider_14.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_14.translatesAutoresizingMaskIntoConstraints = YES;
    
    //Slider 15 Place and Rotate
    sliderFrame.size.width = 320;
    sliderFrame.origin.x = -100.0+60+60+60+60+60+60+60+60+60+60+60+60+60+60;
    sliderFrame.origin.y = 550;
    _slider_15.frame = sliderFrame;
    _slider_15.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _slider_15.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)drawBands{
    //Correct Sizing
    CGRect bandFrame = _band1.frame;
    //Band Label 1 placing
    bandFrame.origin.x = _slider_1.frame.origin.x;
    bandFrame.origin.y = _slider_1.frame.origin.y+330;
    _band1.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band2.frame;
    //Band Label 2 placing
    bandFrame.origin.x = _slider_2.frame.origin.x;
    bandFrame.origin.y = _slider_2.frame.origin.y+330;
    _band2.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band3.frame;
    //Band Label 3 placing
    bandFrame.origin.x = _slider_3.frame.origin.x;
    bandFrame.origin.y = _slider_3.frame.origin.y+330;
    _band3.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band4.frame;
    //Band Label 4 placing
    bandFrame.origin.x = _slider_4.frame.origin.x;
    bandFrame.origin.y = _slider_4.frame.origin.y+330;
    _band4.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band5.frame;
    //Band Label 5 placing
    bandFrame.origin.x = _slider_5.frame.origin.x;
    bandFrame.origin.y = _slider_5.frame.origin.y+330;
    _band5.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band6.frame;
    //Band Label 6 placing
    bandFrame.origin.x = _slider_6.frame.origin.x;
    bandFrame.origin.y = _slider_6.frame.origin.y+330;
    _band6.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band7.frame;
    //Band Label 7 placing
    bandFrame.origin.x = _slider_7.frame.origin.x;
    bandFrame.origin.y = _slider_7.frame.origin.y+330;
    _band7.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band8.frame;
    //Band Label 8 placing
    bandFrame.origin.x = _slider_8.frame.origin.x;
    bandFrame.origin.y = _slider_8.frame.origin.y+330;
    _band8.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band9.frame;
    //Band Label 9 placing
    bandFrame.origin.x = _slider_9.frame.origin.x;
    bandFrame.origin.y = _slider_9.frame.origin.y+330;
    _band9.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band10.frame;
    //Band Label 10 placing
    bandFrame.origin.x = _slider_10.frame.origin.x;
    bandFrame.origin.y = _slider_10.frame.origin.y+330;
    _band10.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band11.frame;
    //Band Label 11 placing
    bandFrame.origin.x = _slider_11.frame.origin.x;
    bandFrame.origin.y = _slider_11.frame.origin.y+330;
    _band11.frame = bandFrame;
    
    //Correct Sizing
    bandFrame = _band12.frame;
    //Band Label 12 placing
    bandFrame.origin.x = _slider_12.frame.origin.x;
    bandFrame.origin.y = _slider_12.frame.origin.y+330;
    _band12.frame = bandFrame;
    
    //Band Label 13 placing
    //Correct Sizing
    bandFrame = _band13.frame;
    bandFrame.origin.x = _slider_13.frame.origin.x;
    bandFrame.origin.y = _slider_13.frame.origin.y+330;
    _band13.frame = bandFrame;
    
    //Band Label 14 placing
    //Correct Sizing
    bandFrame = _band14.frame;
    bandFrame.origin.x = _slider_14.frame.origin.x;
    bandFrame.origin.y = _slider_14.frame.origin.y+330;
    _band14.frame = bandFrame;
    
    //Band Label 15 placing
    //Correct Sizing
    bandFrame = _band15.frame;
    bandFrame.origin.x = _slider_15.frame.origin.x+10;
    bandFrame.origin.y = _slider_15.frame.origin.y+330;
    _band15.frame = bandFrame;
}

- (void)drawDBwithOffset:(float)offset{   //Get Correct Sizing
    CGRect DBFrame = _current1.frame;
    
    //DB1
    DBFrame.origin.x = _slider_1.frame.origin.x;
    DBFrame.origin.y = _slider_1.frame.origin.y-offset;
    _current1.frame = DBFrame;
    
    //DB2
    DBFrame.origin.x = _slider_2.frame.origin.x;
    DBFrame.origin.y = _slider_2.frame.origin.y-offset;
    _current2.frame = DBFrame;
    
    //DB3
    DBFrame.origin.x = _slider_3.frame.origin.x;
    DBFrame.origin.y = _slider_3.frame.origin.y-offset;
    _current3.frame = DBFrame;
    
    //DB4
    DBFrame.origin.x = _slider_4.frame.origin.x;
    DBFrame.origin.y = _slider_4.frame.origin.y-offset;
    _current4.frame = DBFrame;
    
    //DB5
    DBFrame.origin.x = _slider_5.frame.origin.x;
    DBFrame.origin.y = _slider_5.frame.origin.y-offset;
    _current5.frame = DBFrame;
    
    //DB6
    DBFrame.origin.x = _slider_6.frame.origin.x;
    DBFrame.origin.y = _slider_6.frame.origin.y-offset;
    _current6.frame = DBFrame;
    
    //DB7
    DBFrame.origin.x = _slider_7.frame.origin.x;
    DBFrame.origin.y = _slider_7.frame.origin.y-offset;
    _current7.frame = DBFrame;
    
    //DB8
    DBFrame.origin.x = _slider_8.frame.origin.x;
    DBFrame.origin.y = _slider_8.frame.origin.y-offset;
    _current8.frame = DBFrame;
    
    //DB9
    DBFrame.origin.x = _slider_9.frame.origin.x;
    DBFrame.origin.y = _slider_9.frame.origin.y-offset;
    _current9.frame = DBFrame;
    
    //DB10
    DBFrame.origin.x = _slider_10.frame.origin.x;
    DBFrame.origin.y = _slider_10.frame.origin.y-offset;
    _current10.frame = DBFrame;
    
    //DB11
    DBFrame.origin.x = _slider_11.frame.origin.x;
    DBFrame.origin.y = _slider_11.frame.origin.y-offset;
    _current11.frame = DBFrame;
    
    //DB12
    DBFrame.origin.x = _slider_12.frame.origin.x;
    DBFrame.origin.y = _slider_12.frame.origin.y-offset;
    _current12.frame = DBFrame;
    
    //DB13
    DBFrame.origin.x = _slider_13.frame.origin.x;
    DBFrame.origin.y = _slider_13.frame.origin.y-offset;
    _current13.frame = DBFrame;
    
    //DB14
    DBFrame.origin.x = _slider_14.frame.origin.x;
    DBFrame.origin.y = _slider_14.frame.origin.y-offset;
    _current14.frame = DBFrame;
    
    //DB15
    DBFrame.origin.x = _slider_15.frame.origin.x;
    DBFrame.origin.y = _slider_15.frame.origin.y-offset;
    _current15.frame = DBFrame;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_slider_1 release];
    [_slider_2 release];
    [_slider_3 release];
    [_slider_4 release];
    [_slider_5 release];
    [_slider_6 release];
    [_slider_7 release];
    [_slider_8 release];
    [_slider_9 release];
    [_slider_9 release];
    [_slider_10 release];
    [_band1 release];
    [_band2 release];
    [_band3 release];
    [_band3 release];
    [_band5 release];
    [_band6 release];
    [_band7 release];
    [_band8 release];
    [_band9 release];
    [_band10 release];
    [_current1 release];
    [_current2 release];
    [_current3 release];
    [_current4 release];
    [_current5 release];
    [_current6 release];
    [_current7 release];
    [_current8 release];
    [_current9 release];
    [_current10 release];
    [_slider_11 release];
    [_slider_12 release];
    [_slider_13 release];
    [_slider_14 release];
    [_slider_15 release];
    [_current11 release];
    [_current12 release];
    [_current13 release];
    [_current14 release];
    [_current15 release];
    [_band11 release];
    [_band12 release];
    [_band13 release];
    [_band14 release];
    [_band15 release];
    [_visualize release];
    [_display release];
    [_playPause release];
    [_songPicker release];
    [_bassSlider release];
    [_midSlider release];
    [_trebleSlider release];
    [_bassLabel release];
    [_midLabel release];
    [_trebleLabel release];
    [super dealloc];
}

- (IBAction)slider1Changed:(UISlider *)sender{
    PEQ[1].G = (int)sender.value;
    _current1.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
    [appDelegate setCurrent1:(int)sender.value];
}

- (IBAction)slider2Changed:(UISlider *)sender{
    PEQ[2].G = sender.value;
    _current2.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider3Changed:(UISlider *)sender{
    PEQ[3].G = sender.value;
    _current3.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider4Changed:(UISlider *)sender{
    PEQ[4].G = sender.value;
    _current4.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider5Changed:(UISlider *)sender{
    PEQ[5].G = sender.value;
    _current5.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider6Changed:(UISlider *)sender{
    PEQ[6].G = sender.value;
    _current6.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider7Changed:(UISlider *)sender{
    PEQ[7].G = sender.value;
    _current7.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider8Changed:(UISlider *)sender{
    PEQ[8].G = sender.value;
    _current8.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider9Changed:(UISlider *)sender{
    PEQ[9].G = sender.value;
    _current9.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider10Changed:(UISlider *)sender{
    PEQ[10].G = sender.value;
    _current10.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider11Changed:(UISlider *)sender {

    PEQ[11].G = sender.value;
    _current11.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider12Changed:(UISlider *)sender {
    PEQ[12].G = sender.value;
    _current12.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider13Changed:(UISlider *)sender {
    PEQ[13].G = sender.value;
    _current13.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider14Changed:(UISlider *)sender {

    PEQ[14].G = sender.value;
    _current14.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)slider15Changed:(UISlider *)sender {

    PEQ[15].G = sender.value;
    _current15.text = [NSString stringWithFormat:@"%idB",(int)sender.value];
}

- (IBAction)stopButton:(UIButton *)sender {
    if ([audioManager playing])
    {
        NSLog(@"Pausing");
        [audioManager pause];
        //_playPause.titleLabel.text = @"Play";
        [_playPause setTitle:@"Play" forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"Playing");
        [audioManager play];
        //_playPause.titleLabel.text = @"Pause";
        [_playPause setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetBtn:(UIButton *)sender {
    [_slider_1 setValue:0.0];
    PEQ[1].G = 0.0;
    _current1.text = @"0dB";
    [_slider_2 setValue:0.0];
    PEQ[2].G = 0.0;
    _current2.text = @"0dB";
    [_slider_3 setValue:0.0];
    PEQ[3].G = 0.0;
    _current3.text = @"0dB";
    [_slider_4 setValue:0.0];
    PEQ[4].G = 0.0;
    _current4.text = @"0dB";
    [_slider_5 setValue:0.0];
    PEQ[5].G = 0.0;
    _current5.text = @"0dB";
    [_slider_6 setValue:0.0];
    PEQ[6].G = 0.0;
    _current6.text = @"0dB";
    [_slider_7 setValue:0.0];
    PEQ[7].G = 0.0;
    _current7.text = @"0dB";
    [_slider_8 setValue:0.0];
    PEQ[8].G = 0.0;
    _current8.text = @"0dB";
    [_slider_9 setValue:0.0];
    PEQ[9].G = 0.0;
    _current9.text = @"0dB";
    [_slider_10 setValue:0.0];
    PEQ[10].G = 0.0;
    _current10.text = @"0dB";
    [_slider_11 setValue:0.0];
    PEQ[11].G = 0.0;
    _current11.text = @"0dB";
    [_slider_12 setValue:0.0];
    PEQ[12].G = 0.0;
    _current12.text = @"0dB";
    [_slider_13 setValue:0.0];
    PEQ[13].G = 0.0;
    _current13.text = @"0dB";
    [_slider_14 setValue:0.0];
    PEQ[14].G = 0.0;
    _current14.text = @"0dB";
    [_slider_15 setValue:0.0];
    PEQ[15].G = 0.0;
    _current15.text = @"0dB";
    
    [_bassSlider setValue:0.0];
    [_midSlider setValue:0.0];
    [_trebleSlider setValue:0.0];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [titleArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [titleArray objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self startSelectionWithIndex:row];
}

- (void)startSelectionWithIndex:(NSInteger)row {
    switch (row)
    {
        case 0:
            {
                NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"07 Runaway" withExtension:@"mp3"];
                
                //Reads in mp3
                fileReader = [[AudioFileReader alloc]
                              initWithAudioFileURL:inputFileURL
                              samplingRate:audioManager.samplingRate
                              numChannels:audioManager.numOutputChannels];
                
                //Plays the song
                [fileReader play];
                
                [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels)
                 {
                     // pull data from the filereader
                     [fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
                     
                     // apply the filter
                     for (int i = 0; i < 15; i++)
                     {
                         [PEQ[i] filterData:outData numFrames:numFrames numChannels:numChannels];
                         //Here is where I would implement Beat Detection Algorithm-Already split into bands
                         //Copy outData
                         //float *newData = outData;
                         
                         //Full Wave Rectify & Down Sample(2)
                         //int k = 2;
//                         for (int j = 0; j < numFrames; j++)
//                         {
//                             newData[j] = fabsf(newData[k*j]);
//                         }
                         
//                         //Normalize (Mean Removal)
//                         float mean = 0.0;
//                         for (int n = 0; n < numFrames/k; n++)
//                         {
//                             mean = mean + newData[n];
//                         }
//                         mean = mean/(numFrames/k);
//                         for (int i = 0; i < numFrames/k; i++)
//                         {
//                             newData[i] = newData[i] - mean;
//                         }
//                         
//                         //AutoCorrelation Function->BPM
//                         //Sum up x[n]
//                         float x_n = 0.0;
//                         float y_k[256];
//                         for (int j = 2; j < numFrames/k+2; j++)
//                         {
//                             for (int i = 0; i < numFrames/k; i++)
//                             {
//                                 x_n = x_n + newData[i]*newData[i-j];
//                             }
//                             y_k[j-2] = (1/256)*x_n;
//                         }
                         
                     }
                     
                     // measure output level
                     _level = [outputWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
                     
                     
                     //NSLog(@"%f", _level);
                     
                     EqualizerAppDelegate *appDel;
                     appDel = [[UIApplication sharedApplication] delegate];
                     [appDel setLevel:_level];
                     
                     [self performSelectorOnMainThread:@selector(quickUpdate) withObject:nil waitUntilDone:NO];
                     [_visualizer performSelectorOnMainThread:@selector(updateWithLevel) withObject:nil waitUntilDone:NO];
                 }];
            }
            break;
        case 1:
            {
                NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"13 99 Red Balloons" withExtension:@"mp3"];
                
                //Reads in mp3
                fileReader = [[AudioFileReader alloc]
                              initWithAudioFileURL:inputFileURL
                              samplingRate:audioManager.samplingRate
                              numChannels:audioManager.numOutputChannels];
                
                //Plays the song
                [fileReader play];
                
                [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels)
                 {
                     // pull data from the filereader
                     [fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
                     
                     // apply the filter
                     for (int i = 0; i < 15; i++)
                     {
                         [PEQ[i] filterData:outData numFrames:numFrames numChannels:numChannels];
                         //Here is where I would implement Beat Detection Algorithm-Already split into bands
                         //Either create a new EQ Object
                         //Create LowPass Filter(Envelope Detector)
                         //Envelope Detector is the amplitude of "outData"
                         //Full Wave Rectifier
                         //Downsample
                         //Normalize
                         //AutoCorrelation Function->BPM
                     }
                     
                     // measure output level
                     _level = [outputWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
                     
                     
                     //NSLog(@"%f", _level);
                     
                     EqualizerAppDelegate *appDel;
                     appDel = [[UIApplication sharedApplication] delegate];
                     [appDel setLevel:_level];
                     
                     [self performSelectorOnMainThread:@selector(quickUpdate) withObject:nil waitUntilDone:NO];
                     [_visualizer performSelectorOnMainThread:@selector(updateWithLevel) withObject:nil waitUntilDone:NO];
                 }];
            }
        break;
        case 2:
            {
                NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"01 Paradise" withExtension:@"mp3"];
                
                //Reads in mp3
                fileReader = [[AudioFileReader alloc]
                              initWithAudioFileURL:inputFileURL
                              samplingRate:audioManager.samplingRate
                              numChannels:audioManager.numOutputChannels];
                
                //Plays the song
                [fileReader play];
                
                [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels)
                 {
                     // pull data from the filereader
                     [fileReader retrieveFreshAudio:outData numFrames:numFrames numChannels:numChannels];
                     
                     // apply the filter
                     for (int i = 0; i < 15; i++)
                     {
                         [PEQ[i] filterData:outData numFrames:numFrames numChannels:numChannels];
                     }
                     
                     // measure output level
                     _level = [outputWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
                     
                     EqualizerAppDelegate *appDel;
                     appDel = [[UIApplication sharedApplication] delegate];
                     [appDel setLevel:_level];
                     
                     [self performSelectorOnMainThread:@selector(quickUpdate) withObject:nil waitUntilDone:NO];
                     [_visualizer performSelectorOnMainThread:@selector(updateWithLevel) withObject:nil waitUntilDone:NO];
                 }];
            }
        default:
            break;
    }
}

- (IBAction)bassChanged:(UISlider *)sender {
    //Change Slider Value
    [_slider_1 setValue:(int)sender.value];
    [_slider_2 setValue:(int)sender.value];
    [_slider_3 setValue:(int)sender.value];
    [_slider_4 setValue:(int)sender.value];
    [_slider_5 setValue:(int)sender.value];
    
    //Update EQ
    PEQ[1].G = (int)sender.value;
    PEQ[2].G = (int)sender.value;
    PEQ[3].G = (int)sender.value;
    PEQ[4].G = (int)sender.value;
    PEQ[5].G = (int)sender.value;

    //Update Labels
    [_current1 setText:[NSString stringWithFormat:@"%idB", (int)_slider_1.value]];
    [_current2 setText:[NSString stringWithFormat:@"%idB", (int)_slider_1.value]];
    [_current3 setText:[NSString stringWithFormat:@"%idB", (int)_slider_1.value]];
    [_current4 setText:[NSString stringWithFormat:@"%idB", (int)_slider_1.value]];
    [_current5 setText:[NSString stringWithFormat:@"%idB", (int)_slider_1.value]];
    [_bassLabel setTextColor:[UIColor cyanColor]];
    [_bassLabel setAlpha:0.75f];
    [_bassLabel setText:[NSString stringWithFormat:@"%idB", (int)_bassSlider.value]];
}

- (IBAction)bassDoneEdit:(UISlider *)sender {
    [_bassLabel setTextColor:[UIColor whiteColor]];
    [_bassLabel setText:@"Bass"];
    [_bassLabel setAlpha:1.0f];
}

- (IBAction)midChanged:(UISlider *)sender {
    //Change Slider Values
    [_slider_6 setValue:(int)sender.value];
    [_slider_7 setValue:(int)sender.value];
    [_slider_8 setValue:(int)sender.value];
    [_slider_9 setValue:(int)sender.value];
    [_slider_10 setValue:(int)sender.value];
    
    //Update EQ
    PEQ[6].G = (int)sender.value;
    PEQ[7].G = (int)sender.value;
    PEQ[8].G = (int)sender.value;
    PEQ[9].G = (int)sender.value;
    PEQ[10].G = (int)sender.value;

    
    //Update Labels
    [_current6 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current7 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current8 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current9 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current10 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_midLabel setTextColor:[UIColor cyanColor]];
    [_midLabel setAlpha:0.75f];
    [_midLabel setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
}

- (IBAction)midDoneEdit:(UISlider *)sender {

    [_midLabel setTextColor:[UIColor whiteColor]];
    [_midLabel setText:@"Mid"];
    [_midLabel setAlpha:1.0f];
}

- (IBAction)trebleChanged:(UISlider *)sender {
    //Change Slider Values
    [_slider_11 setValue:(int)sender.value];
    [_slider_12 setValue:(int)sender.value];
    [_slider_13 setValue:(int)sender.value];
    [_slider_14 setValue:(int)sender.value];
    [_slider_15 setValue:(int)sender.value];
    
    //Update EQ
    PEQ[11].G = (int)sender.value;
    PEQ[12].G = (int)sender.value;
    PEQ[13].G = (int)sender.value;
    PEQ[14].G = (int)sender.value;
    PEQ[15].G = (int)sender.value;

    
    //Update Labels
    [_current11 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current12 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current13 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current14 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_current15 setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
    [_trebleLabel setTextColor:[UIColor cyanColor]];
    [_trebleLabel setAlpha:0.75f];
    [_trebleLabel setText:[NSString stringWithFormat:@"%idB", (int)sender.value]];
}

- (IBAction)trebleDoneEdit:(UISlider *)sender {
    [_trebleLabel setTextColor:[UIColor whiteColor]];
    [_trebleLabel setText:@"Treble"];
    [_trebleLabel setAlpha:1.0f];


}

@end
