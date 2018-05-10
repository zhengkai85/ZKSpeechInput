//
//  AudioTool.m
//  Speech
//
//  Created by zhengkai on 2018/5/9.
//  Copyright © 2018年 zhengkai. All rights reserved.
//

#import "AudioTool.h"
#import <Speech/Speech.h>
#import "AudioRecogize.h"

@interface AudioTool ()
@property (nonatomic, strong) AudioRecogize *audioRecogize;
@end

@implementation AudioTool

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self selfInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self selfInit];
    }
    return self;
}

- (void)selfInit {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  Registering for keyboard notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    });
    
    
    self.btnRecord = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80,
                                                                0,
                                                                70,
                                                                self.bounds.size.height)];
    self.btnRecord.backgroundColor = [UIColor orangeColor];
    [self.btnRecord setTitle:@"语音录入" forState:UIControlStateNormal];
    self.btnRecord.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.btnRecord];
    
    [self.btnRecord addTarget:self action:@selector(recordTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.btnRecord addTarget:self action:@selector(recordTouchDragExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecord addTarget:self action:@selector(recordTouchDragEnter:) forControlEvents:UIControlEventTouchDown];
    
    self.spectrumView = [[SpectrumView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       100,
                                                                       self.btnRecord.frame.size.height)];
    [self addSubview:self.spectrumView];
}

- (AudioRecogize *)audioRecogize {
    if(!_audioRecogize) {
        _audioRecogize = [[AudioRecogize alloc] init];
        
        __weak AudioTool *weakSelf = self;
        _audioRecogize.recogizeCallback = ^(BOOL isSucess, NSString *callBackMessage) {
            if(weakSelf.recogizeCallback) {
                weakSelf.recogizeCallback(isSucess, callBackMessage);
            }
        };
    }
    return _audioRecogize;
}

-(void)dealloc {
    //Removing notification observers on dealloc.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)recordTouchDragExit:(UIButton *)button {
    [self.spectrumView stopShow];
    [self.audioRecogize endRecording];
}

- (void)recordTouchDragEnter:(UIButton *)button {
    [self.spectrumView startShow];
    [self.audioRecogize startRecording];
}


- (void)keyboardWillChangeFrame:(NSNotification*)note {
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect rectBtn = self.frame;
        rectBtn.origin.y = rect.origin.y - rectBtn.size.height;
        self.frame = rectBtn;
    }];
}


@end
