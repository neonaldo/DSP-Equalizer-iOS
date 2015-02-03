//
//  visualizerView.m
//  DSP_EQ_iPad
//
//  Created by Joey La Barck on 5/5/14.
//  Copyright (c) 2014 Joey La Barck. All rights reserved.
//

#import "visualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "EqualizerViewController.h"
#import "EqualizerAppDelegate.h"

@implementation visualizerView
{
    CAEmitterLayer *emitterLayer;
    EqualizerViewController *eq;
}

// 1
+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        // 2
        CGFloat width = 900;
        CGFloat height = 1;
        emitterLayer.emitterPosition = CGPointMake((1024/2)-20,50);
        emitterLayer.emitterSize = CGSizeMake(width,height);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        // 3
        cell = [CAEmitterCell emitterCell];
        cell.name = @"cell";
        cell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        
        // 4
        cell.color = [[UIColor cyanColor] CGColor];
        cell.redRange = 0.55f;
        cell.greenRange = 0.4f;
        cell.blueRange = 0.7f;
        cell.alphaRange = 0.85f;
        
        // 5
        cell.redSpeed = 0.11f;
        cell.greenSpeed = 0.07f;
        cell.blueSpeed = -0.25f;
        cell.alphaSpeed = 0.15f;
        
        // 6
        cell.scale = 0.5f;
        cell.scaleRange = 0.5f;
        
        // 7
        cell.lifetime = 1.0f;
        cell.lifetimeRange = .25f;
        cell.birthRate = 80;
        
        // 8
        cell.velocity = 250.0f;
        cell.velocityRange = 0.0f;
        cell.emissionRange = M_PI * 2;
        
        // 9
        emitterLayer.emitterCells = @[cell];
    }
    
//    CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithLevel:)];
//    [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)updateWithLevel
{
    EqualizerAppDelegate *AppDel;
    AppDel = [[UIApplication sharedApplication] delegate];
    
    
    float NewLevel = [AppDel getLevel];
    
    //NSLog(@"Level: %f", NewLevel);
    
    if ( NewLevel > -30 && NewLevel < -20)
    {
        cell.color = [[UIColor blackColor] CGColor];
    }
    else{
        cell.color = [[UIColor cyanColor] CGColor];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
