//
//  AudioTool.h
//  Speech
//
//  Created by zhengkai on 2018/5/9.
//  Copyright © 2018年 zhengkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpectrumView.h"

@interface AudioTool : UIView
@property (nonatomic, strong) UIButton *btnRecord;
@property (nonatomic, strong) SpectrumView *spectrumView;
@property (nonatomic, copy) void (^recogizeCallback)(BOOL isSucess,NSString *callBackMessage);
@end
