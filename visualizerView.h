//
//  visualizerView.h
//  DSP_EQ_iPad
//
//  Created by Joey La Barck on 5/5/14.
//  Copyright (c) 2014 Joey La Barck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface visualizerView : UIView
{
    CAEmitterCell *cell;
}

@property (nonatomic) CAEmitterCell *cell;

//- (void)updateWithLevel:(float)level;
- (void)updateWithLevel;

@end
