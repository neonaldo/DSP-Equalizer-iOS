//
//  EqualizerViewController.h
//  DSP_EQ_iPad
//
//  Created by Joey La Barck on 4/29/14.
//  Copyright (c) 2014 Joey La Barck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"
#import "NVDSP.h"
#import "NVHighpassFilter.h"
#import "NVBandpassQPeakGainFilter.h"
#import "NVPeakingEQFilter.h"
#import "NVSoundLevelMeter.h"
#import "visualizerView.h"
#import "EqualizerAppDelegate.h"
#import "NVLowpassFilter.h"

@interface EqualizerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    //EQ
    RingBuffer *ringBuffer;
    Novocaine *audioManager;
    AudioFileReader *fileReader;
    AudioFileWriter *fileWriter;
    NVHighpassFilter *HPF;
    NVBandpassQPeakGainFilter *BPF;
    float QFactor;
    float initialGain;
    NVPeakingEQFilter *PEQ[15];
    NVSoundLevelMeter *inputWatcher;
    NVSoundLevelMeter *outputWatcher;
    float inputLevelBuffer;
    //float level;
    
    //Intermediates
    float compareLevel;
    NSArray *titleArray;
    EqualizerAppDelegate *appDelegate;
    
    //Wavelet
    NVLowpassFilter *LPF1;
}
@property (strong, nonatomic) visualizerView *visualizer;
@property (retain, nonatomic) IBOutlet UIView *visualize;
@property (retain, nonatomic) IBOutlet UILabel *display;

- (IBAction)resetBtn:(UIButton *)sender;
- (IBAction)stopButton:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIPickerView *songPicker;

@property (nonatomic) float level;

@property float HPF_cornerFrequency;
@property float sQ1;

@property (retain, nonatomic) IBOutlet UISlider *slider_1;
@property (retain, nonatomic) IBOutlet UISlider *slider_2;
@property (retain, nonatomic) IBOutlet UISlider *slider_3;
@property (retain, nonatomic) IBOutlet UISlider *slider_4;
@property (retain, nonatomic) IBOutlet UISlider *slider_5;
@property (retain, nonatomic) IBOutlet UISlider *slider_6;
@property (retain, nonatomic) IBOutlet UISlider *slider_7;
@property (retain, nonatomic) IBOutlet UISlider *slider_8;
@property (retain, nonatomic) IBOutlet UISlider *slider_9;
@property (retain, nonatomic) IBOutlet UISlider *slider_10;
@property (retain, nonatomic) IBOutlet UISlider *slider_11;
@property (retain, nonatomic) IBOutlet UISlider *slider_12;
@property (retain, nonatomic) IBOutlet UISlider *slider_13;
@property (retain, nonatomic) IBOutlet UISlider *slider_14;
@property (retain, nonatomic) IBOutlet UISlider *slider_15;

@property (retain, nonatomic) IBOutlet UIButton *playPause;

@property (retain, nonatomic) IBOutlet UILabel *band1;
@property (retain, nonatomic) IBOutlet UILabel *band2;
@property (retain, nonatomic) IBOutlet UILabel *band3;
@property (retain, nonatomic) IBOutlet UILabel *band4;
@property (retain, nonatomic) IBOutlet UILabel *band5;
@property (retain, nonatomic) IBOutlet UILabel *band6;
@property (retain, nonatomic) IBOutlet UILabel *band7;
@property (retain, nonatomic) IBOutlet UILabel *band8;
@property (retain, nonatomic) IBOutlet UILabel *band9;
@property (retain, nonatomic) IBOutlet UILabel *band10;
@property (retain, nonatomic) IBOutlet UILabel *band11;
@property (retain, nonatomic) IBOutlet UILabel *band12;
@property (retain, nonatomic) IBOutlet UILabel *band13;
@property (retain, nonatomic) IBOutlet UILabel *band14;
@property (retain, nonatomic) IBOutlet UILabel *band15;

@property (retain, nonatomic) IBOutlet UILabel *current1;
@property (retain, nonatomic) IBOutlet UILabel *current2;
@property (retain, nonatomic) IBOutlet UILabel *current3;
@property (retain, nonatomic) IBOutlet UILabel *current4;
@property (retain, nonatomic) IBOutlet UILabel *current5;
@property (retain, nonatomic) IBOutlet UILabel *current6;
@property (retain, nonatomic) IBOutlet UILabel *current7;
@property (retain, nonatomic) IBOutlet UILabel *current8;
@property (retain, nonatomic) IBOutlet UILabel *current9;
@property (retain, nonatomic) IBOutlet UILabel *current10;
@property (retain, nonatomic) IBOutlet UILabel *current11;
@property (retain, nonatomic) IBOutlet UILabel *current12;
@property (retain, nonatomic) IBOutlet UILabel *current13;
@property (retain, nonatomic) IBOutlet UILabel *current14;
@property (retain, nonatomic) IBOutlet UILabel *current15;

- (IBAction)slider1Changed:(UISlider *)sender;
- (IBAction)slider2Changed:(UISlider *)sender;
- (IBAction)slider3Changed:(UISlider *)sender;
- (IBAction)slider4Changed:(UISlider *)sender;
- (IBAction)slider5Changed:(UISlider *)sender;
- (IBAction)slider6Changed:(UISlider *)sender;
- (IBAction)slider7Changed:(UISlider *)sender;
- (IBAction)slider8Changed:(UISlider *)sender;
- (IBAction)slider9Changed:(UISlider *)sender;
- (IBAction)slider10Changed:(UISlider *)sender;
- (IBAction)slider11Changed:(UISlider *)sender;
- (IBAction)slider12Changed:(UISlider *)sender;
- (IBAction)slider13Changed:(UISlider *)sender;
- (IBAction)slider14Changed:(UISlider *)sender;
- (IBAction)slider15Changed:(UISlider *)sender;

@property (retain, nonatomic) IBOutlet UISlider *bassSlider;
@property (retain, nonatomic) IBOutlet UISlider *midSlider;
@property (retain, nonatomic) IBOutlet UISlider *trebleSlider;

- (IBAction)bassChanged:(UISlider *)sender;
- (IBAction)midChanged:(UISlider *)sender;
- (IBAction)trebleChanged:(UISlider *)sender;

@property (retain, nonatomic) IBOutlet UILabel *bassLabel;
@property (retain, nonatomic) IBOutlet UILabel *midLabel;
@property (retain, nonatomic) IBOutlet UILabel *trebleLabel;

- (IBAction)bassDoneEdit:(UISlider *)sender;
- (IBAction)midDoneEdit:(UISlider *)sender;
- (IBAction)trebleDoneEdit:(UISlider *)sender;


@end
