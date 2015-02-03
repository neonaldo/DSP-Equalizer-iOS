#import "NVDSP.h"

@interface NVClippingDetection : NVDSP {
    float threshold;
}

- (float) getClippedPercentage:(float*)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
- (UInt32) getClippedSamples:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;
- (float) getClippingSample:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

- (void) counterClipping:(float *)outData numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end
