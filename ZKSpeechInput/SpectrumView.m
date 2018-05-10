//
//  SpectrumView.m
//  GYSpectrum
//
//  Created by 黄国裕 on 16/8/19.
//  Copyright © 2016年 黄国裕. All rights reserved.
//

#import "SpectrumView.h"

@interface SpectrumView ()

@property (nonatomic, strong) NSMutableArray * levels;
@property (nonatomic, strong) NSMutableArray * itemLineLayers;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat lineWidth;//自适应

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) AudioSave *audioSave;
@end

@implementation SpectrumView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    self.numberOfItems = 20.f;//偶数

    self.itemColor = [UIColor colorWithRed:241/255.f green:60/255.f blue:57/255.f alpha:1.0];

    self.middleInterval = 5.f;
    
//    self.timeLabel = [[UILabel alloc]init];
//    self.timeLabel.text = @"";
//    [self.timeLabel setTextColor:[UIColor grayColor]];
//    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:self.timeLabel];
    
    __weak SpectrumView * weakSelf = self;
    self.itemLevelCallback = ^{
        [weakSelf.audioSave.audioRecorder updateMeters];
        float power= [weakSelf.audioSave.audioRecorder averagePowerForChannel:0];
        weakSelf.level = power;
    };
    
}


- (AudioSave *)audioSave {
    if(!_audioSave) {
        _audioSave = [[AudioSave alloc] init];
    }
    return _audioSave;
}

- (AVAudioRecorder *)audioRecorder {
    return self.audioSave.audioRecorder;
}


#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];

    self.itemHeight = CGRectGetHeight(self.bounds);
    self.itemWidth = CGRectGetWidth(self.bounds);

    [self.timeLabel sizeToFit];
    self.timeLabel.center = CGPointMake(self.itemWidth * 0.5f, self.itemHeight * 0.5f);

    self.lineWidth = (self.itemWidth - self.middleInterval) / 2.f / self.numberOfItems;
    
    self.level = -120;

}

#pragma mark - setter

- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    for (CAShapeLayer *itemLine in self.itemLineLayers) {
        itemLine.strokeColor = [self.itemColor CGColor];
    }
}

- (void)setNumberOfItems:(NSUInteger)numberOfItems {
    if (_numberOfItems == numberOfItems) {
        return;
    }
    _numberOfItems = numberOfItems;

    self.levels = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.numberOfItems / 2 ; i++){
        [self.levels addObject:@(0)];
    }


    for (CAShapeLayer *itemLine in self.itemLineLayers) {
        [itemLine removeFromSuperlayer];
    }
    self.itemLineLayers = [NSMutableArray array];
    for(int i=0; i < numberOfItems; i++) {
        CAShapeLayer *itemLine = [CAShapeLayer layer];
        itemLine.lineCap       = kCALineCapButt;
        itemLine.lineJoin      = kCALineJoinRound;
        itemLine.strokeColor   = [[UIColor clearColor] CGColor];
        itemLine.fillColor     = [[UIColor clearColor] CGColor];
        itemLine.strokeColor   = [self.itemColor CGColor];
        itemLine.lineWidth     = self.lineWidth;

        [self.layer addSublayer:itemLine];
        [self.itemLineLayers addObject:itemLine];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        for (CAShapeLayer *itemLine in self.itemLineLayers) {
            itemLine.lineWidth = lineWidth;
        }
    }
}

- (void)setItemLevelCallback:(void (^)(void))itemLevelCallback {
    _itemLevelCallback = itemLevelCallback;
}


- (void)setLevel:(CGFloat)level {
    level = (level+37.5)*3.2;
    if( level < 0 ) level = 0;

    [self.levels removeObjectAtIndex:self.numberOfItems/2-1];
    [self.levels insertObject:@(level / 6.f) atIndex:0];
    
    [self updateItems];
    
}


- (void)setText:(NSString *)text{
    self.timeLabel.text = text;
}

- (void)setMiddleInterval:(CGFloat)middleInterval {
    if (_middleInterval != middleInterval) {
        _middleInterval = middleInterval;
        [self setNeedsLayout];
    }
}


#pragma mark - update

- (void)updateItems {
    //NSLog(@"updateMeters");

    UIGraphicsBeginImageContext(self.frame.size);

    int lineOffset = self.lineWidth * 2.f;

    int leftX = (self.itemWidth - self.middleInterval + self.lineWidth) / 2.f;
    int rightX = (self.itemWidth + self.middleInterval - self.lineWidth) / 2.f;


    for(int i = 0; i < self.numberOfItems / 2; i++) {

        CGFloat lineHeight = self.lineWidth + [self.levels[i] floatValue] * self.lineWidth;
        //([[self.levels objectAtIndex:i]intValue]+1)*self.lineWidth/2.f;

        CGFloat lineTop = (self.itemHeight - lineHeight) / 2.f;
        CGFloat lineBottom = (self.itemHeight + lineHeight) / 2.f;

        leftX -= lineOffset;

        UIBezierPath *linePathLeft = [UIBezierPath bezierPath];
        [linePathLeft moveToPoint:CGPointMake(leftX, lineTop)];
        [linePathLeft addLineToPoint:CGPointMake(leftX, lineBottom)];
        CAShapeLayer *itemLine2 = [self.itemLineLayers objectAtIndex:i + self.numberOfItems / 2];
        itemLine2.path = [linePathLeft CGPath];


        rightX += lineOffset;

        UIBezierPath *linePathRight = [UIBezierPath bezierPath];
        [linePathRight moveToPoint:CGPointMake(rightX, lineTop)];
        [linePathRight addLineToPoint:CGPointMake(rightX, lineBottom)];
        CAShapeLayer *itemLine = [self.itemLineLayers objectAtIndex:i];
        itemLine.path = [linePathRight CGPath];
    }
    
    UIGraphicsEndImageContext();
}

- (void)startShow {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:_itemLevelCallback selector:@selector(invoke)];
//        self.displayLink.frameInterval = 6.f;
        self.displayLink.preferredFramesPerSecond = 6.f;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.audioSave startRecording];
    }
}

- (void)stopShow {
    [self.displayLink invalidate];
    self.displayLink = nil;
    [self.audioSave endRecording];
    
    [self.levels removeAllObjects];
    for(int i = 0 ; i < self.numberOfItems / 2 ; i++){
        [self.levels addObject:@(0)];
    }
    [self updateItems];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
