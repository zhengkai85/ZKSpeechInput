//
//  AudioSave.h
//  Speech
//
//  Created by zhengkai on 2018/5/9.
//  Copyright © 2018年 zhengkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioSave : NSObject


- (void)startRecording;
- (void)endRecording;
- (float)getCurrentPower;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机

@end
