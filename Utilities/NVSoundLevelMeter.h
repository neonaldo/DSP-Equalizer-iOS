#import "NVDSP.h"

@interface NVSoundLevelMeter : NVDSP {
    float dBLevel;
}

- (float) getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

@end
