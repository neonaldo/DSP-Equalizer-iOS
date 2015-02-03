//
//  EqualizerAppDelegate.h
//  DSP_EQ_iPad
//
//  Created by Joey La Barck on 4/29/14.
//  Copyright (c) 2014 Joey La Barck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqualizerAppDelegate : UIResponder <UIApplicationDelegate>
{
    float level;
    int current1;
}

@property (strong, nonatomic) UIWindow *window;

- (void)setCurrent1:(int)value;
- (int)getCurrent1;

- (void)setLevel:(float)newLev;
- (float)getLevel;

@end
