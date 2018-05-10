//
//  ViewController.m
//  Speech
//
//  Created by zhengkai on 2018/5/8.
//  Copyright © 2018年 zhengkai. All rights reserved.
//

#import "ViewController.h"
#import <Speech/Speech.h>
#import "AudioRecogize.h"
#import "AudioTool.h"

@interface ViewController ()
@property (nonatomic, strong) AudioTool *audioToolView;
@property (nonatomic, strong) UITextField *txt1;

@end

@implementation ViewController

-(instancetype)init
{
    if (self = [super init])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            //  Registering for keyboard notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];        
        });
    }
    return self;
}



-(void)dealloc {
    //Removing notification observers on dealloc.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.txt1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, 300, 40)];
    self.txt1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.txt1];
    
    self.audioToolView = [[AudioTool alloc] initWithFrame:CGRectMake(0,
                                                                     [UIScreen mainScreen].bounds.size.height,
                                                                     [UIScreen mainScreen].bounds.size.height - 100,
                                                                     50)];
    [self.view addSubview:self.audioToolView];
    
    __weak ViewController *weakSelf = self;
    self.audioToolView.recogizeCallback = ^(BOOL isSucess, NSString *callBackMessage) {
        if(isSucess) {
            weakSelf.txt1.text = callBackMessage;
        } else {
            NSLog(@"error message :%@",callBackMessage);
        }
    };
    
}



- (void)keyboardWillShow:(NSNotification*)note {
    self.audioToolView.hidden = NO;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    self.audioToolView.hidden = YES;
}


@end
