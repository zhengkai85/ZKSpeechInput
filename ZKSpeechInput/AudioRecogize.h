//
//  AudioRecogize.h
//  Speech
//
//  Created by zhengkai on 2018/5/9.
//  Copyright © 2018年 zhengkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioRecogize : NSObject

@property (nonatomic, copy) void (^recogizeCallback)(BOOL isSucess,NSString *callBackMessage);

- (void)startRecording;
- (void)endRecording;
@end
